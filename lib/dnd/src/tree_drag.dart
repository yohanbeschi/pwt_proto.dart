part of pwt_dnd;

class TreeDrag extends DraggablePoint {

  final StreamController<PwtDragEvent> _treeMouseOverController = new StreamController.broadcast();
  final StreamController<PwtDragEvent> _treeMouseOutController = new StreamController.broadcast();
  
  List<DropTarget> _dropTargets;
  
  DropTarget activeTarget;
  
  ExtElement _dropZone;
  
  Timer _timer;
  
  TreeDrag(var element, var point, List<dynamic> targets) : super(element, point, CursorPosition.N) {
    _dropTargets = targets.map((target) =>
      target is DropTarget ? target : new DropTarget(target)
    ).toList();
    
    //_treeMouseOverController.stream.listen(_onMouseOver);
    //_treeMouseOutController.stream.listen(_onMouseOut);
  }
  
  void _onMouseOver() {
    
  }
  
  void _onMouseOut() {
    
  }
  
  void startDragMouse(MouseEvent mouseEvent) {
    if (this._dropTargets != null) {

      for (DropTarget dropTarget in this._dropTargets) {
        dropTarget._dropTargetActiveController.add(new DropTargetEvent(this));
      }

      this.mouseCurrent = new MutablePoint(mouseEvent.client.x, mouseEvent.client.y);
    }
    
    _addDocumentListeners(this._dragMouse, this._releaseElement);
  }  
    
  void dragMouse(MouseEvent mouseEvent) {
    super.dragMouse(mouseEvent);
    
    if (this._dropTargets != null) {
      this.mouseCurrent = new MutablePoint(mouseEvent.client.x, mouseEvent.client.y);
    }
    
    _testForDropTargets();
  }
  
  void _testForDropTargets([bool fromTimeout = false]) {
    
    if (this._dragging != _DragState.DRAGGING) {
      return;
    }

    final DropTarget previousTarget = this.activeTarget;
    _findActiveTarget();
    _fireEnterAndLeave(previousTarget);
    _selectTitle();
  }

  void _findActiveTarget() {
    this.selectedTitle = null;
    this.activeTarget = null;
    this.moveElement = null;
    int maxIntersectSize = 0;
    
    for (DropTarget dropTarget in this._dropTargets) {
      if (dropTarget.isEnabled) {
        if (dropTarget.box.containsPoint(this.mouseCurrent)) {
          this.activeTarget = dropTarget;
          break;
        }
      }
    }
  }
  
  ExtElement getTitle(DropTarget dropTarget) {
    return new ExtElement(dropTarget.box.children[0].children[2]);
  }
  
  ExtElement getNode(DropTarget dropTarget) {
    return new ExtElement(dropTarget.box.children[0]);
  }
  
  void _fireEnterAndLeave(DropTarget previousTarget) {
    if (this.activeTarget != previousTarget) {
      if (this.activeTarget != null) {
        this.activeTarget._dropTargetEnterController.add(new DropTargetEvent(this));
        //this._dragEnterController.add(new DragEvent(this));
      }
      
      if (previousTarget != null) {
        previousTarget._dropTargetLeaveController.add(new DropTargetEvent(this));
        //this._dragLeaveController.add(new DragEvent(this));
      }
    }
  }
  
  ExtElement selectedTitle;
  ExtElement previousTitle;
  Function moveElement;
  
  void _selectTitle() {
    if (this.activeTarget != null) {
      final List<Element> children = this.activeTarget.box.queryAll(this.activeTarget._childrenSelector);
      final List<ExtElement> childBoxes = children.map((Element e) => new ExtElement(e)).toList(); 
      
      int totalHeight = this.activeTarget.box.innerOffsetTop();
      final int draggablePosition = mouseCurrent.y - this.box.offsetParentPageTop();
      
      bool placed = false;
      
      ExtElement box;
      ExtElement lastDisplayed;
      for (int i = 0; i < childBoxes.length; i++) {
        box = childBoxes[i];
        
        totalHeight += box.heightMargin();
        
        // We found over which title the mouse is.
        // Now we need to display the drop indicator
        if (draggablePosition <= totalHeight) {
          previousTitle = selectedTitle;
          
          if (box.isDisplayed()) {
            selectedTitle = box;
          } else {
            selectedTitle = lastDisplayed;
          }
          
          if (previousTitle != selectedTitle) {
            displayDropZone();
          }
          placed = true;
          break;
        }
      
        if (box.isDisplayed()) {
          lastDisplayed = box;
        }
      }
      
      if (!placed) {
        previousTitle = selectedTitle;
        selectedTitle = lastDisplayed;
        displayDropZone();
      }
    }
  }
  
  void displayDropZone() {
    final ExtElement marker = $('#dynatree-drop-marker');
    marker.style.display = 'none';
    marker.removeClasses('dynatree-drop-before dynatree-drop-after dynatree-drop-over');
    point.removeClasses('dynatree-drop-reject dynatree-drop-accept');
    
    if (selectedTitle.text == point.text) { 
      point.addClasses('dynatree-drop-reject');
    } else {
      point.addClasses('dynatree-drop-accept');
      
      final Offset elementOffset = selectedTitle.offset();
      final ExtElement node = new ExtElement(selectedTitle.parent);
      final Position position = node.position();

      // Add before
      int mouseFromTop = mouseCurrent.y - elementOffset.top;
      int mouseFromBottom = selectedTitle.heightMargin() - mouseFromTop;
      int middle = selectedTitle.heightMargin() ~/ 2;
      int mouseFromMiddle = middle - mouseFromTop;
      
      //print('${mouseFromTop} ${mouseFromBottom}');
      if (new ExtElement(node.parent).children.length > 1 
          && mouseFromMiddle >= -2 && mouseFromMiddle <= 2) {
        marker.addClasses('dynatree-drop-over');
        marker.style.left = '${position.left}px';
        marker.style.top = '${position.top}px';
        
        moveElement = insertChild(selectedTitle.parent.parent);
      } 
      else if (mouseFromTop < mouseFromBottom) {
        marker.addClasses('dynatree-drop-before');
        marker.style.left = '${position.left}px';
        marker.style.top = '${position.top - 8}px';
        moveElement = insertElement('beforeBegin', selectedTitle.parent.parent);
      } 
      // Add after
      else {
        marker.addClasses('dynatree-drop-after');
        marker.style.left = '${position.left}px';
        marker.style.top = '${position.top + selectedTitle.height - 7}px';
        moveElement = insertElement('afterEnd', selectedTitle.parent.parent);
      }
      
      marker.style.display = 'block';
    }
  }
  
  Function insertChild(Element liElement) {
    return () {
      final Element childLiElement = this.box.parent.parent;
      final Element previousElementSibling = childLiElement.previousElementSibling;
      Element insertInto = null;
      if (liElement.children.length == 1) {
        final UListElement ulElement = new UListElement();
        ulElement.append(childLiElement);
        liElement.append(ulElement);
      } else {
        insertInto = liElement.children[1];
        insertInto.insertAdjacentElement('beforeEnd', childLiElement);
      }
      
      updateClasses(previousElementSibling, liElement, childLiElement);
    };
  }

  Function insertElement(String where, Element parentLiElement) {
    return () {
      final Element liElement = this.box.parent.parent;
      final Element previousElementSibling = liElement.previousElementSibling;
      parentLiElement.insertAdjacentElement(where, liElement);
      
      updateClasses(previousElementSibling, parentLiElement, liElement);
    };
  }
  
  void updateClasses(Element oldPreviousElementSibling, Element parentLiElement, Element childLiElement) {
    //print(oldPreviousElementSibling.innerHtml);
    
    // Does the previous sibling has a next sibling ?
    // If not, it becomes the last sibling
    bool wasNewLast = false;
    if (oldPreviousElementSibling != null && oldPreviousElementSibling.nextElementSibling == null) {
      // The new element was a last sibling
      wasNewLast = true;
      makeLast(oldPreviousElementSibling);
    }
    
    // Was the new previous sibling the last one ?
    // If yes, change it and the new element becomes the last sibling
    if (childLiElement.nextElementSibling == null) {
      final Element previousSibling = childLiElement.previousElementSibling;
      if (previousSibling != null) {
        unlast(previousSibling);
      }
      makeLast(childLiElement);
    } else {
      if (childLiElement.classes.contains('dynatree-lastsib')) {
        unlast(childLiElement);
      }
    }
  }
  
  void unlast(Element element) {
    element.classes.remove('dynatree-lastsib');
    
    final Element child = element.children[0];
    if (child.classes.contains('dynatree-exp-cdl')) {
      element.classes.remove('dynatree-exp-cdl');
      element.classes.add('dynatree-exp-cd');
    } else if (child.classes.contains('dynatree-exp-cl')) {
      child.classes.remove('dynatree-exp-cl');
      child.classes.add('dynatree-exp-c');
    } else if (element.classes.contains('dynatree-exp-el')) {
      element.classes.remove('dynatree-exp-el');
      element.classes.add('dynatree-exp-e');
    } else if (element.classes.contains('dynatree-exp-edl')) {
      element.classes.remove('dynatree-exp-edl');
      element.classes.add('dynatree-exp-ed');
    }
  }
  
  void makeLast(Element element) {
    element.classes.add('dynatree-lastsib');
    
    final Element child = element.children[0];
    if (child.classes.contains('dynatree-exp-cd')) {
      child.classes.remove('dynatree-exp-cd');
      child.classes.add('dynatree-exp-cdl');
    } else if (child.classes.contains('dynatree-exp-c')) {
      child.classes.remove('dynatree-exp-c');
      child.classes.add('dynatree-exp-cl');
    } else if (child.classes.contains('dynatree-exp-e')) {
      child.classes.remove('dynatree-exp-e');
      child.classes.add('dynatree-exp-el');
    } else if (child.classes.contains('dynatree-exp-ed')) {
      child.classes.remove('dynatree-exp-ed');
      child.classes.add('dynatree-exp-edl');
    }
  }
  
  void _releaseElement(MouseEvent mouseEvent) {
    _releaseDragging();
    _removeDocumentListeners();

    if (this._dropTargets != null) {
      for (DropTarget dt in this._dropTargets) {
        final bool droppedOnThis = activeTarget != null && activeTarget == dt;
        dt._dropTargetInactiveController.add(new DropTargetEvent(this, droppedOnThis));
      }
    }
    
    if (this.activeTarget != null) {
      this.activeTarget._dropTargetDropController.add(new DropTargetEvent(this));
    }
    
    final PwtDragEvent dndEvent = new PwtDragEvent(this);
    this._dragDropController.add(dndEvent);
    
    this.endDrag();
  }
  
  void endDrag() {
    _endDragging();

    this.activeTarget = null;
    
    this._dragAfterDropController.add(new PwtDragEvent(this)); 
  }
  
  dynamic noSuchMethod(InvocationMirror invocation) {
    return null;
  }
}