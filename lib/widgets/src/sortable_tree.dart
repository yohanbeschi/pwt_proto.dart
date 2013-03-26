part of pwt_widgets;


class SortableTree {
  final StreamController<SortEvent> _sortController = new StreamController.broadcast();
  
  SortableOptions _options;
  
  bool _itemsInMotion;
  
  ExtElement _tree;
  ExtElement _previous;
  ExtElement _parent;
  
  List<dynamic> containers;
  List<DropTarget> dropTargets;
  
  SortableTree(dynamic tree, [SortableOptions options]) : _itemsInMotion = false {
    if (options != null) {
      _options = options;
    } else {
      _options = new SortableOptions();
    }

    _tree = getExtElement(tree);
    
    // Build Marker
    final DivElement marker = new DivElement();
    marker.style.position = 'absolute';
    marker.classes.add('dynatree-drop-marker');
    marker.style.zIndex = '1000';
    marker.style.display = 'none';
    marker.id = 'dynatree-drop-marker';
    _tree.insertAdjacentElement('beforeBegin', marker);
    
    // Build Helper
    final SpanElement helperImg = new SpanElement();
    helperImg.classes.add('dynatree-drag-helper-img');
    final SpanElement helperTitle = new SpanElement();
    helperTitle.classes.add('dynatree-title');
    
    final DivElement helper = new DivElement();
    helper.style.position = 'absolute';
    helper.classes.add('dynatree-drag-helper');
    helper.style.zIndex = '1000';
    helper.style.display = 'none';
    
    helper.append(helperImg);
    helper.append(helperTitle);
    _tree.insertAdjacentElement('beforeBegin', helper);
    
    //print(_tree.parentElement.innerHtml);
    
    final List<Element> elements = _tree.queryAll('.dynatree-title');
    final List<Element> dtd = [_tree.element]; //queryAll('${tree}'); // li
    final List<DropTarget> dropTargets = new List();
    for (Element e in dtd) {
      var dt = new DropTarget(e, '.dynatree-title');
      dt.dropZoneType = DropZoneType.NONE;
      dropTargets.add(dt);
    }
    
    for (Element e in elements) {
      final TreeDrag dnd = new TreeDrag(e, helper, dropTargets)
        ..onDrag((PwtDragEvent event) { 
          document.body.style.cursor = 'default';
        })
        ..onMove((PwtDragEvent event) { 
          if (helperTitle.text != event.object.box.text) {
            helperTitle.text = event.object.box.text;
            event.object.point.style.display = 'block';
            //marker.style.display = 'block';
          }
        })
        ..onDrop((PwtDragEvent event) { 
          document.body.style.cursor = '';
          marker.style.display = 'none';
          event.object.point.style.display = 'none';
          helperTitle.text= '';
          
          if (event.object.moveElement != null) {
            event.object.moveElement();
          }
          
          _sortController.add(new SortEvent(e));
          event.preventDefault();
        });
    }
  }
  
  void onSort(SortAction sortAction) {
    _sortController.stream.listen(sortAction);
  }
  
  void _handleDrag(PwtDragEvent event) {
    // if items are still in motion, prevent dragging
    if (this._itemsInMotion) {
      event.preventDefault();
      return;
    }

    // stuff is in the air now...
    this._itemsInMotion = true;
  }

  void _handleDrop (PwtDragEvent event) {
      final Element previous = event.object.box.previousElementSibling;
      
      if (previous != null) {
        _previous = new ExtElement(previous);
    
    
        if (_previous.hasClass(this._options._dropZoneClass) ) {
          _previous = new ExtElement(_previous.previousElementSibling);
        }
      } else {
        _previous = null;
      }
  
      this._parent = new ExtElement(event.object.box.parent);

      if (event.object.activeTarget != null && 
          event.object.activeTarget.box.dataset['dnd'] != 'target-only') {
          event.object.activeTarget.moveToPosition(event.object);
      }
  }
  
  void _handleAfterDrop (PwtDragEvent event) {
    final Element previous = event.object.box.previousElementSibling;
    
    if (previous != this._previous 
        || event.object.box.parent != this._parent) {
      this._sortController.add(new SortEvent(this));
    }
    
    // we're done moving
    this._itemsInMotion = false;
    this._previous = null;
    this._parent = null;
  }
}


