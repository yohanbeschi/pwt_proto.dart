part of pwt_dnd;

typedef void DropTargetAction(DropTargetEvent dropEvent);

class DropOptions {
  Tolerance _tolerance;
  DropZoneType _dropZoneType;
  String _dropZoneClass;

  DropOptions() : this._tolerance = Tolerance.INTERSECT,
                  this._dropZoneType = DropZoneType.NONE;
}

class DropTargetEvent {
  var drag;
  bool _droppedOnThis;
  
  DropTargetEvent(this.drag, [this._droppedOnThis = false]);
}

class DropTarget {
  
  final StreamController<DropTargetEvent> _dropTargetActiveController = new StreamController.broadcast();
  final StreamController<DropTargetEvent> _dropTargetInactiveController = new StreamController.broadcast();
  final StreamController<DropTargetEvent> _dropTargetDropController = new StreamController.broadcast();
  final StreamController<DropTargetEvent> _dropTargetLeaveController = new StreamController.broadcast();
  final StreamController<DropTargetEvent> _dropTargetEnterController = new StreamController.broadcast();
  
  DropOptions _options;
  
  ExtElement box;
  List<ExtElement> _childBoxes;
  ExtElement dropZone;
  
  int _dropIndicatorAt;
  
  int _logicalBottom;

  StreamSubscription<DropTargetEvent> _onActiveListener;
  StreamSubscription<DropTargetEvent> _onInactiveListener;
  StreamSubscription<DropTargetEvent> _onEnterListener;
  StreamSubscription<DropTargetEvent> _onLeaveListener;
  
  bool isEnabled = true;
  dynamic _childrenSelector;
  
  DropTarget(dynamic element, [String childrenSelector]) {
    assertTrue(element is String || element is Element);

    box = element is String ? $(element) : new ExtElement(element);
    _childrenSelector = childrenSelector;
    _options = new DropOptions();
    _onActiveListener = _dropTargetActiveController.stream.listen(_onActive);
    _onInactiveListener = _dropTargetInactiveController.stream.listen(_onInactive);
  }
  
  StreamSubscription<DropTargetEvent> onActive(DropTargetAction dropTargetAction) 
    => this._dropTargetActiveController.stream.listen(dropTargetAction);
  
  StreamSubscription<DropTargetEvent> onInactive(DropTargetAction dropTargetAction) 
    => this._dropTargetInactiveController.stream.listen(dropTargetAction);
  
  StreamSubscription<DropTargetEvent> onDrop(DropTargetAction dropTargetAction) 
    => this._dropTargetDropController.stream.listen(dropTargetAction);
  
  StreamSubscription<DropTargetEvent> onLeave(DropTargetAction dropTargetAction) 
    => this._dropTargetLeaveController.stream.listen(dropTargetAction);
  
  StreamSubscription<DropTargetEvent> onEnter(DropTargetAction dropTargetAction) 
    => this._dropTargetEnterController.stream.listen(dropTargetAction);
  
    set tolerance(Tolerance tolerance) 
      => this._options._tolerance = tolerance;
    
    set dropZoneType(DropZoneType dropZoneType) 
    => this._options._dropZoneType = dropZoneType;
    
    set dropZoneClass(String dropZoneClass) 
    => this._options._dropZoneClass = dropZoneClass;
  
  void _onActive(DropTargetEvent dropEvent) {
    if (this._logicalBottom != null) {
      this.box.setLogicalBottom(this._logicalBottom);
    }
    
    if (this._options._dropZoneType == DropZoneType.NONE) {
      return;
    }
    
    _onEnterListener = _dropTargetEnterController.stream.listen(_onEnter);
    _onLeaveListener = _dropTargetLeaveController.stream.listen(_onLeave);
    
    final Element dropZoneElement = _createPlaceholderElement(dropEvent.drag.box.element);
    this.dropZone = new ExtElement(dropZoneElement);
    
    if (this._options._dropZoneClass != null) {
      this.dropZone.classes.add(this._options._dropZoneClass);
    }
    
    if (this._options._dropZoneType == DropZoneType.SPACER) {
      dropEvent.drag.box.sizePlaceholder(this.dropZone.element, 0, 0, 'relative');
    }
    
    // Get all children that are not placeholders or a dropZones
    final List<Element> children = this.box.children.where((Element e) 
          => (dropEvent.drag._startingZone == null 
               || dropEvent.drag._startingZone != e)
             && (e != this.dropZone)).toList();

    
    // Children as Boxes
    this._childBoxes = children.map((Element e) => new ExtElement(e)).toList(); 
  }
  
  void _onInactive(DropTargetEvent dropEvent) {
    if (this._onEnterListener != null) {
      this._onEnterListener.cancel();
    }
    
    if (this._onLeaveListener != null) {
      this._onLeaveListener.cancel();
    }

    if (this._options._dropZoneType == DropZoneType.NONE) {
      return;
    }
    
    // Remove drop indicator
    if (!dropEvent._droppedOnThis && this.dropZone != null) {
      this.dropZone.remove();
      this.dropZone = null;
    }
    
    this._childBoxes = null;
  }
  
  void _onEnter (DropTargetEvent dropEvent) {
    this._dropIndicatorAt = -1;
  }
  
  void _onLeave(DropTargetEvent dropEvent) {
    this.dropZone.remove();
  }
  
  void setLogicalBottom (int bottom) {
    this._logicalBottom = bottom;
  }
  
  /**
   * Insert the draggable's element within the drop target where the drop indicator currently is. Sets
   *   the start offset of the drag to the position of the drop indicator so that it will be animated
   *   to it's final location, rather than where the drag started.
   */
  void moveToPosition(var drag) {
    drag.startPosition = this.dropZone.position();
    drag._dropZone = this.dropZone;
    this.dropZone = null;
  }
  
  void enable() { isEnabled = true; }
  void disable() { isEnabled = false; }
}