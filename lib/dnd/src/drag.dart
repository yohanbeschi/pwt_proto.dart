part of pwt_dnd;

typedef void DragAction(DragEvent event);

class DragOptions {
  PlaceholderType _placeholderType;
  String _placeholderClass;
  var _handle;
  var _container;
  bool _onlyUpperLimits;
  Axis _axis;
  Step _step;
  
  DragOptions(): this._placeholderType = PlaceholderType.NONE,
                  this._onlyUpperLimits = false,
                  this._step = new Step.same(1);
  
  set placeholderType(PlaceholderType placeholderType) 
    => _placeholderType = placeholderType;
  
  set placeholderClass(String placeholderClass)
    => _placeholderClass = placeholderClass;
  
  set handle(dynamic handle)
    => _handle = handle;
  
  set container(var container)
    => _container = container;
  
  set axis(Axis axis) => _axis = axis;
  
  get placeholderType => _placeholderType;
  get placeholderClass => _placeholderClass;
  get handle => _handle;
  get container => _container;
  get axis => _axis;
}

class DragEvent {
  _ADrag drag;
  
  bool _defaultPrevented = false;
  
  DragEvent(this.drag);
  
  void preventDefault() {
    _defaultPrevented = true;
  }
  
  bool get defaultPrevented => _defaultPrevented;
}

abstract class _ADrag {
  final StreamController<DragEvent> _dragMoveController = new StreamController.broadcast();
  final StreamController<DragEvent> _dragDragController = new StreamController.broadcast();
  final StreamController<DragEvent> _dragEnterController = new StreamController.broadcast();
  final StreamController<DragEvent> _dragLeaveController = new StreamController.broadcast();
  final StreamController<DragEvent> _dragDropController = new StreamController.broadcast();
  final StreamController<DragEvent> _dragAfterDropController = new StreamController.broadcast();
  
  List<StreamSubscription<Event>> _listeners;
  StreamSubscription<Event> _handleListener;
  
  DragOptions _options;
  
  _DragState _dragging;
  
  ExtElement box;
  ExtElement _startingZone; //*
  
  Position startPosition;
  String _preDragPosition; //*
  String _preDragZIndex; //*
  int _startLeft; //*
  int _startTop; //*

  Point _mouseStart;
  Position currentPosition;
  Position deltaPosition;
  
  Bounds _bounds;
  
  bool isEnabled = true;
  
  int cumulativeHeight;
  int cumulativeWidth;
  int topLimit;
  int bottomLimit;
  int leftLimit;
  int rightLimit;
  
  _ADrag(dynamic element) {
    box = getExtElement(element);
    _dragging = _DragState.READY;
    _options = new DragOptions();
    _listeners = new List();
    _handleListener = box.onMouseDown.listen(this._startDragMouse);
  }
  
  StreamSubscription<DragEvent> onMove(DragAction dragAction) 
    => this._dragMoveController.stream.listen(dragAction);
  
  StreamSubscription<DragEvent> onDrag(DragAction dragAction) 
    => this._dragDragController.stream.listen(dragAction);
  
  StreamSubscription<DragEvent> onEnter(DragAction dragAction) 
    => this._dragEnterController.stream.listen(dragAction);
  
  StreamSubscription<DragEvent> onLeave(DragAction dragAction) 
    => this._dragLeaveController.stream.listen(dragAction);
  
  StreamSubscription<DragEvent> onDrop(DragAction dragAction) 
    => this._dragDropController.stream.listen(dragAction);
  
  StreamSubscription<DragEvent> onAfterDrop(DragAction dragAction) 
    => this._dragAfterDropController.stream.listen(dragAction);
  
    set placeholderType(PlaceholderType placeholderType) 
      => _options._placeholderType = placeholderType;
  
    set placeholderClass(String placeholderClass)
      => _options._placeholderClass = placeholderClass;
    
    set handle(dynamic handle) {
      assertTrue(handle is String || handle is Element);

      _options._handle = handle is String ? $('#${box.id} ${handle}') : new ExtElement(handle);
      _handleListener.cancel();
      _options._handle.onMouseDown.listen(this._startDragMouse);
    }
    
    set container(var container) {
      assertTrue(container is String || container is Element || container is ExtElement);
      
      _options._container = container is String ? $(container) 
          : container is Element ? new ExtElement(container)
          : container;
    }
    
    set axis(Axis axis) => this._options._axis = axis;
    
  void step(int x, [int y]) {
    if (y == null) {
      this._options._step = new Step.same(x);
    } else {
      this._options._step = new Step(x, y);
    }
  }
    
  void enableOnlyUpperLimits() {_options._onlyUpperLimits = true;}
    
  bool _startDragMouse(MouseEvent mouseEvent) {
    if (!isEnabled) {
      return false;  
    }
    
    // cancel out any text selections
    document.body.focus();
    
    if(!_startDragging()) {
      return false;
    }

    _prepareBox(mouseEvent);
    _setBounds();
    _setManualLimits();
    
    return true;
  }
  
  bool _startDragging() {
    // Fire Drag
    final DragEvent dragEvent = new DragEvent(this);
    this._dragDragController.add(dragEvent);
    if (dragEvent._defaultPrevented) {
      return false;
    }
    
    if (this._dragging == _DragState.DRAGGING) {
      this.endDrag();
      return false;
    } else if (this._dragging != _DragState.READY) {
      return false;
    }
    
    this._dragging = _DragState.DRAGGING;

    return true;
  }

  void _prepareBox(MouseEvent mouseEvent) {
    // Save start drag infos
    this._mouseStart = new Point(mouseEvent.pageX, mouseEvent.pageY); 
    this.startPosition = this.box.position();
    this.currentPosition = new Position(this.startPosition.x, this.startPosition.y);
    this._preDragPosition = this.box.getComputedStyle().getPropertyValue('position');
    this._preDragZIndex = this.box.getComputedStyle().getPropertyValue('z-index');
    this._startLeft = this.box.val('left');
    this._startTop = this.box.val('top');
    
    _makePlaceholder();
    
    // Set properties to element
    this.box.style.setProperty('z-index', '10000');
    this.box.style.setProperty('position', 'absolute');
    this.box.style.setProperty('left', '${this.startPosition.x}px');
    this.box.style.setProperty('top', '${this.startPosition.y}px');
  }
  
  void _setBounds() {
    if (this._options._container != null) {
      this._bounds = this._options._container.innerBounds(this.box);
      
      if (_options._step._x != 1) {
        this._bounds._left -= (this._bounds._left - this.startPosition.x) % _options._step._x;
        this._bounds._right -= (this._bounds._right - this.startPosition.x) % _options._step._x;
      }
      
      if (_options._step._y != 1) {
        this._bounds._top -= (this._bounds._top - this.startPosition.y) % _options._step._y;
        this._bounds._bottom -= (this._bounds._bottom - this.startPosition.y) % _options._step._y;
      }
    } else {
      this._bounds = null;
    }
  }
  
  void _setManualLimits() {
    if (topLimit != null) {
      topLimit = startPosition.top - topLimit;
    }
    if (bottomLimit != null) {
      bottomLimit += startPosition.top;
    }
    if (leftLimit != null) {
      leftLimit = startPosition.left - leftLimit;
    }
    if (rightLimit != null) {
      rightLimit += startPosition.left;
    }
  }
  
  void _makePlaceholder() {
    if (_options._placeholderType != PlaceholderType.NONE) {
      Element placeholderElement;
      
      if (_options._placeholderType == PlaceholderType.CLONE) {
        placeholderElement = this.box.clone(true);
      } else {
        placeholderElement = _createPlaceholderElement(this.box.element);
      }
      
      if (this._options._placeholderClass != null) {
        
        placeholderElement.classes.add(this._options._placeholderClass);
      }
      
      placeholderElement.style.zIndex = _preDragZIndex;
      this.box.sizePlaceholder(placeholderElement, this._startLeft, this._startTop);
      
      this.box.insertAdjacentElement('afterEnd', placeholderElement);
      this._startingZone = new ExtElement(placeholderElement);
    }
  }
  
  void _addDocumentListeners(void onMouseMove(Event event), void onMouseUp(Event event)) {
    _listeners.add(document.onSelectStart.listen((Event e) => e.preventDefault()));
    _listeners.add(document.onDragStart.listen((Event e) => e.preventDefault()));
    _listeners.add(document.onMouseDown.listen((Event e) => e.preventDefault()));
    _listeners.add(document.onMouseMove.listen(onMouseMove));
    _listeners.add(document.onMouseUp.listen(onMouseUp));
  }
  
  void _dragMouse(MouseEvent mouseEvent) {
    final Position position = new Position(0, 0);
    
    _setPositionWithAxis(mouseEvent, position);
    _setPositionWithStep(position);
    _setPositionWithBounds(position);
    _setPositionWithSize(position);
    _setNewPosition(position);
  }
  
  void _setPositionWithAxis(MouseEvent mouseEvent, final Position position) {
    if (this._options._axis == Axis.X_AXIS) {
      position.top = this.startPosition.top;
      position.left = this.startPosition.x + mouseEvent.pageX - this._mouseStart.x;
    } else if (this._options._axis == Axis.Y_AXIS) {
      position.top = this.startPosition.top + mouseEvent.pageY - this._mouseStart.y;
      position.left = this.startPosition.x;
    } else {
      position.top = this.startPosition.top + mouseEvent.pageY - this._mouseStart.y;
      position.left = this.startPosition.left + mouseEvent.pageX - this._mouseStart.x;
    }
  }
  
  void _setPositionWithStep(final Position position) {
    if (_options._step._x != 1) {
      position.left = round((position.left - this.startPosition.left) / _options._step._x) 
                      * _options._step._x + this.startPosition.left;
    }
    if (_options._step._y != 1) {
      position.top = round((position.top - this.startPosition.top) / _options._step._y) 
                      * _options._step._y + this.startPosition.top;
    }
  }
  
  void _setPositionWithBounds(final Position position) {
    if (this._bounds != null) {
      // only apply bounds on the axis we're using
      if (this._options._axis != Axis.Y_AXIS) {
        if (position.left < this._bounds.left) {
          position.left = this._bounds.left;
        } else if (!this._options._onlyUpperLimits && position.left > this._bounds.right) {
          position.left = this._bounds.right;
        }
      }
      
      if (this._options._axis != Axis.X_AXIS) {
        if (position.top < this._bounds.top) {
          position.top = this._bounds.top;
        } else if (!this._options._onlyUpperLimits && position.top > this._bounds.bottom) {
          position.top = this._bounds.bottom;
        }
      }
    }
  }
  
  void _setPositionWithSize(final Position position) {
    if (this._options._axis != Axis.Y_AXIS) {
      if (leftLimit != null && position.left < leftLimit) {
        position.left = leftLimit;
      } else if (rightLimit  != null && position.left > rightLimit) {
        position.left = rightLimit;
      }
    }

    if (this._options._axis != Axis.X_AXIS) {
      if (topLimit != null && position.top < topLimit) {
        position.top = topLimit;
      } else if (bottomLimit  != null && position.top > bottomLimit) {
        position.top = bottomLimit;
      }
    }
    
    this.deltaPosition = new Position(position.left - currentPosition.left, position.top - currentPosition.top);
  }
  
  void _setNewPosition(final Position position) {
    this.box.style.left = '${position.left}px';
    this.box.style.top = '${position.top}px';

    this._dragMoveController.add(new DragEvent(this));
    this.currentPosition = new Position(position.left, position.top);
  }
  
  void _releaseElement(MouseEvent mouseEvent) {
    _releaseDragging();
    _removeDocumentListeners();
    
    this._dragDropController.add(new DragEvent(this));

    endDrag();
  }
  
  void _releaseDragging() {
    if (this._dragging != _DragState.DRAGGING) {
      return;
    }

    this._dragging = _DragState.END;
  }
  
  void _removeDocumentListeners() {
    for (StreamSubscription<Event> streamSubscription in this._listeners) {
      streamSubscription.cancel();
    }
    this._listeners.clear();
  }
  
  void endDrag(){
    _endDragging();
    
    if (this._startingZone != null) {
      this._startingZone.element.remove();
      this._startingZone = null;
    }
    
    this._resetPosition();

    this._dragAfterDropController.add(new DragEvent(this));
  }
  
  void _endDragging() {
    if (this._dragging != _DragState.END) {
      return;
    }

    this._dragging = _DragState.READY;
  }
  
  void _resetPosition();
  
  void _setFinalPosition() {
    final Position position = this.box.position();
    
    final CssStyleDeclaration css = this.box.style;
    final String currentPosition = css.position;
    css.zIndex = this._preDragZIndex;
    
    if (this._preDragPosition == 'static' 
        && position.top == startPosition.y 
        && position.left == startPosition.x) {
      css.position = 'static';
      css.left = '';
      css.top = '';
    } else {
      css.position = this._preDragPosition == 'static' ? 'relative' : this._preDragPosition;
      
      int newLeft;
      int newTop;
      
      if (this._preDragPosition == 'static') {
        newLeft = position.left - startPosition.x;
        newTop = position.top - startPosition.y;
      } else if (this._preDragPosition == 'relative' && currentPosition != 'relative') {
        newLeft = this._startLeft + (position.left - startPosition.x);
        newTop = this._startTop + (position.top - startPosition.y);
      }
      
      if (this._preDragPosition != currentPosition) {
        css.left = newLeft != null ? '${newLeft}px' : '';
        css.top = newTop != null ? '${newTop}px' : '';
      }
    }
  }
  
  void enable() { isEnabled = true; }
  void disable() { isEnabled = false; }
}

class Draggable extends _ADrag {
  Draggable(dynamic element) : super(element);
  
  _startDragMouse(MouseEvent mouseEvent) {
    if (super._startDragMouse(mouseEvent)) {
      
      _addDocumentListeners(this._dragMouse, this._releaseElement);
      
      mouseEvent.preventDefault(); 
    }
  }
  
  void _dragMouse(MouseEvent mouseEvent) {
    super._dragMouse(mouseEvent);
    
    mouseEvent.preventDefault();
  }
  
  void _resetPosition() {
    this._setFinalPosition();
  }
}