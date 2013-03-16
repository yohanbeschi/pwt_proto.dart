part of pwt_dnd;

class DndEvent extends DragEvent {
  DragNDrop drag;

  DndEvent(drag) : super(drag) {
    this.drag = drag;
  }
}

class DragNDrop extends _ADrag {
  
  List<DropTarget> _dropTargets;
  
  Point _mouseCurrent;
  
  DropTarget activeTarget;
  
  ExtElement _dropZone;
  
  DragNDrop(var element, List<dynamic> targets) : super(element) {
    _dropTargets = targets.map((target) =>
      target is DropTarget ? target : new DropTarget(target)
    ).toList();
  }
  
  _startDragMouse(MouseEvent mouseEvent) {
    if (super._startDragMouse(mouseEvent)) {

      if (this._dropTargets != null) {
  
        for (DropTarget dropTarget in this._dropTargets) {
          dropTarget._dropTargetActiveController.add(new DropTargetEvent(this));
        }
  
        this._mouseCurrent = new Point(mouseEvent.clientX, mouseEvent.clientY);
  
        this._testForDropTargets();
      }
      
      _addDocumentListeners(this._dragMouse, this._releaseElement);
      
      mouseEvent.preventDefault();
    }
  }  
    
  void _dragMouse(MouseEvent mouseEvent) {
    super._dragMouse(mouseEvent);
    
    if (this._dropTargets != null) {
      this._mouseCurrent = new Point(mouseEvent.clientX, mouseEvent.clientY);
    }
    
    _testForDropTargets();
    
    mouseEvent.preventDefault();
  }
  
  void _testForDropTargets([bool fromTimeout = false]) {
    
    if (this._dragging != _DragState.DRAGGING) {
      return;
    }
    
    final DropTarget previousTarget = this.activeTarget;
    _findActiveTarget();
    _fireEnterAndLeave(previousTarget);
    _addDropZone();
  }

  void _findActiveTarget() {
    this.activeTarget = null;
    int maxIntersectSize = 0;
    
    for (DropTarget dropTarget in this._dropTargets) {
      if (dropTarget.isEnabled) {
        if (dropTarget._options._tolerance == Tolerance.CONTAINED) {
          if (dropTarget.box.contains(box)) {
            this.activeTarget = dropTarget;
            break;
          }
        } else if (dropTarget._options._tolerance == Tolerance.CURSOR) {
          if (dropTarget.box.containsPoint(this._mouseCurrent)) {
            this.activeTarget = dropTarget;
            break;
          }
        } else {
          final int intersectSize = dropTarget.box.intersectSize(box, true);
          
          if (intersectSize > maxIntersectSize) {
            maxIntersectSize = intersectSize;
            this.activeTarget = dropTarget;
          }
        }
      }
    }
  }
  
  void _fireEnterAndLeave(DropTarget previousTarget) {
    if (this.activeTarget != previousTarget) {
      if (this.activeTarget != null) {
        this.activeTarget._dropTargetEnterController.add(new DropTargetEvent(this));
        this._dragEnterController.add(new DragEvent(this));
      }
      
      if (previousTarget != null) {
        previousTarget._dropTargetLeaveController.add(new DropTargetEvent(this));
        this._dragLeaveController.add(new DragEvent(this));
      }
    }
  }
  
  void _addDropZone() {
    if (this.activeTarget != null && this.activeTarget._options._dropZoneType != DropZoneType.NONE) {
      int totalHeight = this.activeTarget.box.innerOffsetTop();
      final int draggablePosition = _mouseCurrent.y - this.box.offsetParentPageTop();

      bool placed = false;
      int index = 0;
      if (this.activeTarget._childBoxes != null) {
        for (ExtElement box in this.activeTarget._childBoxes) {
  
          // TODO: Element equality
          if (box.element == this.box.element) continue; 
          
          // TODO: Horizontal DnD
          
          totalHeight += box.heightMargin();
          
          
          if (draggablePosition <= totalHeight) {
           // if (this.activeTarget._dropIndicatorAt != index) {
              box.insertAdjacentElement('beforeBegin', this.activeTarget.dropZone.element);
              this.activeTarget._dropIndicatorAt = index;
            //}
            placed = true;
            break;
          }
          
          index++;
        }
      }
      
      if (!placed) {
        if (this.activeTarget._childBoxes != null && !this.activeTarget._childBoxes.isEmpty) {
          this.activeTarget._childBoxes.last.insertAdjacentElement('afterEnd', this.activeTarget.dropZone.element);
          this.activeTarget._dropIndicatorAt = index + 1;
        }
        else {
          this.activeTarget.box.append(this.activeTarget.dropZone.element);
          this.activeTarget._dropIndicatorAt = 0;
        }
      }
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
    
    final DndEvent dndEvent = new DndEvent(this);
    this._dragDropController.add(dndEvent);
    
    if (!dndEvent.defaultPrevented) {
      this.returnHome();
    } else {
      this.endDrag();
    }
  }
  
  void returnHome([Tween tween]){
    if (tween == null) {
      tween = linear();
    }
    
    final Position position = this.box.position();
    final num distance = pow(
        pow(this.startPosition.left - position.left, 2)
        + pow(this.startPosition.top - position.top, 2),
        0.5
    );
    final num duration = 0.3 + (distance / 1000);

    final Animation animation = new Animation(this.box.element, duration, 
        {'top': '${this.startPosition.top}px',
         'left': '${this.startPosition.left}px'},
        new AnimationOptions(tween:tween));     
        
    final List<List<Animation>> channels = new List();
    channels.add([animation]);
    
    if (this._dropZone != null) {
      final Animation dropAnim = new Animation(this._dropZone.element, duration - 0.1, 
        {'opacity': 0},
        new AnimationOptions());
      
      channels.add([dropAnim]);
    }
    
    final Timeline timeline = new Timeline(channels);
    timeline.onComplete((Timeline t) =>  this.endDrag());
    timeline.start();
  }
  
  void endDrag() {
    _endDragging();
    
    if (this._startingZone != null) {
      this._startingZone.element.remove();
      this._startingZone = null;
    }
    
    this._resetPosition();

    this.activeTarget = null;
    
    this._dragAfterDropController.add(new DragEvent(this)); 
  }
  
  void _resetPosition() {
    this._setFinalPosition();
    
    if (this._startingZone != null || this._dropZone != null) {
      this.box.remove();
    }
    
    if (this._dropZone != null) {
      this._dropZone.replaceWith(this.box.element);
      this._dropZone = null;
      
      if (this._startingZone != null) {
        this._startingZone.remove();
        this._startingZone = null;
      }
      
      // this is canceling out some of the stuff done in the if statement above, could be done better
      final CssStyleDeclaration css = this.box.style;
      css.position = _preDragPosition;
      if (this._preDragPosition == 'relative' && currentPosition != 'relative') {
        css.left = '${this._startLeft}px';
        css.top = '${this._startTop}px';
      }
    }
    else if (this._startingZone != null) {
      this._startingZone.replaceWith(this.box.element);
      this._startingZone = null;
    }
  }
}