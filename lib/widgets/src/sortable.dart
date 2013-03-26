part of pwt_widgets;

typedef void SortAction(SortEvent event);

class SortableOptions extends DragOptions {
  bool _equaliseColumns;
  String _dropZoneClass;
  
  SortableOptions() : _equaliseColumns = true;
  
    set equaliseColumns(bool equaliseColumns) => _equaliseColumns = equaliseColumns;
    set dropZoneClass(String dropZoneClass) => _dropZoneClass = dropZoneClass;
}

class SortEvent {
  var sortable;
  
  SortEvent(this.sortable);
}

class Sortable {
  final StreamController<SortEvent> _sortController = new StreamController.broadcast();
  
  SortableOptions _options;
  
  bool _itemsInMotion;
  
  ExtElement _previous;
  ExtElement _parent;
  
  List<DropTarget> dropTargets;
  
  Sortable(List<dynamic> containers, [SortableOptions options]) : _itemsInMotion = false {
    if (options != null) {
      _options = options;
    } else {
      _options = new SortableOptions();
    }
    
    this.dropTargets = new List();
    
    var buildDT = (dropTarget) {
      if (dropTarget is DropTarget) {;
        this.dropTargets.add(dropTarget);
      } else {
        final DropTarget dt = new DropTarget(dropTarget);
        dt.dropZoneType = DropZoneType.SPACER;
        
        if (_options._dropZoneClass != null) {
          dt.dropZoneClass = _options._dropZoneClass;
        }
        
        this.dropTargets.add(dt);
      }
    };
    
    containers.forEach((e) => buildDT(e));
    
    this.dropTargets
      .where((e) => e.box.dataset['dnd'] != 'target-only').toList()
      .forEach((e) => addItems(e.box.children));
  }
  
  void onSort(SortAction sortAction) {
    _sortController.stream.listen(sortAction);
  }
  
  void _handleDrag(DragEvent event) {
    // if items are still in motion, prevent dragging
    if (this._itemsInMotion) {
      event.preventDefault();
      return;
    }
    
    if (this._options._equaliseColumns) {
      equaliseColumns();
    }
    
    // stuff is in the air now...
    this._itemsInMotion = true;
  }
  
  void equaliseColumns () {
    int maxBottom = 0;
    int bottom = 0;
    
    for (DropTarget dropTarget in this.dropTargets) {
      int currentTop = dropTarget.box.position().top;
      bottom = currentTop + dropTarget.box.offsetHeight;
      
      if (bottom > maxBottom) {
        maxBottom = bottom;
      }
    }

    for (DropTarget dropTarget in this.dropTargets) {
      dropTarget.setLogicalBottom(maxBottom);
    }
  }
  
  void _handleDrop (DragEvent event) {
      DndEvent dndEvent = event;
      
      final Element previous = event.drag.box.previousElementSibling;
      
      if (previous != null) {
        _previous = new ExtElement(previous);
    
    
        if (_previous.hasClass(this._options._dropZoneClass) ) {
          _previous = new ExtElement(_previous.previousElementSibling);
        }
      } else {
        _previous = null;
      }
  
      this._parent = new ExtElement(event.drag.box.parent);

      if (dndEvent.drag.activeTarget != null && 
          dndEvent.drag.activeTarget.box.dataset['dnd'] != 'target-only') {
        dndEvent.drag.activeTarget.moveToPosition(event.drag);
      }
  }
  
  void _handleAfterDrop (DragEvent event) {
    final Element previous = event.drag.box.previousElementSibling;
    
    if (previous != this._previous 
        || event.drag.box.parent != this._parent) {
      this._sortController.add(new SortEvent(this));
    }
    
    // we're done moving
    this._itemsInMotion = false;
    this._previous = null;
    this._parent = null;
  }
  
  void addItems(List<Element> elements) {
    for (Element e in elements) {

      final DragNDrop dnd = new DragNDrop(e, this.dropTargets);
      
      if (this._options.placeholderType != null) {
        dnd.placeholderType = this._options.placeholderType;
      }
      
      dnd.axis = this._options.axis;
      
      if (this._options.container != null) {
        dnd.container = this._options.container;
      }
      
      if (this._options.handle != null) {
        dnd.handle = this._options.handle;
      }
      
      dnd.onDrag(_handleDrag);
      dnd.onDrop(_handleDrop);
      dnd.onAfterDrop(_handleAfterDrop);
    }
  }
}
