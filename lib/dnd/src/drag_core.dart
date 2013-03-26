part of pwt_dnd;

typedef void PwtDrag(PwtDragEvent event);

class PwtDragCoreOptions extends PwtOptions {
  static final String _onDrag = "onDrag";
  static final String _onTakeoff = "onTakeoff";
  static final String _onMove = "onMove";
  static final String _onDrop = "onDrop";
  static final String _onAfterDrop = "onAfterDrop";
  static final String _onlyUpperLimits = "onlyUpperLimits";
  static final String _container = "container";
  static final String _axis = "axis";
  static final String _step = "step";
  static final String _cursorAsOrigin = "cursorAsOrigin";
  
  PwtDragCoreOptions() : super();
  PwtDragCoreOptions.map(Map<String, dynamic> options) : super.map(options);
  
    set onDrag(PwtDrag pwtDrag) => set(_onDrag, pwtDrag);
    set onTakeoff(PwtDrag pwtDrag) => set(_onTakeoff, pwtDrag);
    set onMove(PwtDrag pwtDrag) => set(_onMove, pwtDrag);
    set onDrop(PwtDrag pwtDrag) => set(_onDrop, pwtDrag);
    set onAfterDrop(PwtDrag pwtDrag) => set(_onAfterDrop, pwtDrag);
    
    set container(dynamic container) => set(_container, getExtElement(container));
    set onlyUpperLimits(bool onlyUpperLimits) => set(_onlyUpperLimits, onlyUpperLimits);
    set axis(Axis axis) => set(_axis, axis);
    set step(Step step) => set(_step, step);
    set cursorAsOrigin(bool cursorAsOrigin) => set(_cursorAsOrigin, cursorAsOrigin);
    
  PwtDrag get onDrag => get(_onDrag);
  PwtDrag get onTakeoff => get(_onTakeoff);
  PwtDrag get onMove => get(_onMove);
  PwtDrag get onDrop => get(_onDrop);
  PwtDrag get onAfterDrop => get(_onAfterDrop);
  
  ExtElement get container => get(_container);
  bool get onlyUpperLimits => get(_onlyUpperLimits);
  Axis get axis => get(_axis);
  Step get step => get(_step);
  bool get cursorAsOrigin => get(_cursorAsOrigin);
}

class PwtDragEvent {
  var _object;
  
  bool _defaultPrevented = false;
  
  PwtDragEvent(var this._object);
  
  void preventDefault() {
    _defaultPrevented = true;
  }
  
  bool get defaultPrevented => _defaultPrevented;
  dynamic get object => _object;
}

abstract class _DragCore {
  final StreamController<PwtDragEvent> _dragDragController = new StreamController.broadcast();
  final StreamController<PwtDragEvent> _dragTakeoffController = new StreamController.broadcast();
  final StreamController<PwtDragEvent> _dragMoveController = new StreamController.broadcast();
  final StreamController<PwtDragEvent> _dragDropController = new StreamController.broadcast();
  final StreamController<PwtDragEvent> _dragAfterDropController = new StreamController.broadcast();
  
  List<StreamSubscription<Event>> _listeners;
  StreamSubscription<Event> _handleListener;
  
  _DragState _dragging;
  
  PwtDragCoreOptions _options;

  ExtElement box;
  
  Position startPosition;
  Position currentPosition;
  Position deltaPosition;
  
  Point mouseStart;
  Point mouseCurrent;

  Bounds _bounds;
  
  bool isEnabled = true;
  
  _DragCore(dynamic element, [PwtDragCoreOptions options]) {
    box = getExtElement(element);
    _dragging = _DragState.READY;
    _listeners = new List();
    _handleListener = box.onMouseDown.listen(this._startDragMouse);
    
    this._options = options != null ? options : new PwtOptions();
    options.apply(PwtDragCoreOptions._onDrag, onDrag);
    options.apply(PwtDragCoreOptions._onTakeoff, onTakeoff);
    options.apply(PwtDragCoreOptions._onMove, onMove);
    options.apply(PwtDragCoreOptions._onDrop, onDrop);
    options.apply(PwtDragCoreOptions._onAfterDrop, onAfterDrop);
    options.apply(PwtDragCoreOptions._onlyUpperLimits, null, false);
    options.apply(PwtDragCoreOptions._step, null, new Step.same(1));
    options.apply(PwtDragCoreOptions._cursorAsOrigin, null, false);
  }
  
  StreamSubscription<PwtDragEvent> onDrag(PwtDrag pwtDrag) 
  => this._dragDragController.stream.listen(pwtDrag);
  
  StreamSubscription<PwtDragEvent> onTakeoff(PwtDrag pwtDrag) 
  => this._dragTakeoffController.stream.listen(pwtDrag);
  
  StreamSubscription<PwtDragEvent> onMove(PwtDrag pwtDrag) 
    => this._dragMoveController.stream.listen(pwtDrag);

  StreamSubscription<PwtDragEvent> onDrop(PwtDrag pwtDrag) 
    => this._dragDropController.stream.listen(pwtDrag);
  
  StreamSubscription<PwtDragEvent> onAfterDrop(PwtDrag pwtDrag) 
    => this._dragAfterDropController.stream.listen(pwtDrag);

  void _startDragMouse(MouseEvent mouseEvent) {
    if (!isEnabled) {
      return;  
    }
    
    // cancel out any text selections
    document.body.focus();
    
    if(!_startDragging()) {
      return;
    }

    this.mouseStart = new Point(mouseEvent.pageX, mouseEvent.pageY); 
    this.startPosition = box.position();
    
    if (_options.cursorAsOrigin) {
      ExtElement extElement = new ExtElement(mouseEvent.target);
      startPosition.top = mouseEvent.clientY - extElement.offset().top + startPosition.top + extElement.val('margin-top');
      startPosition.left = mouseEvent.clientX - extElement.offset().left + startPosition.left+ extElement.val('margin-left');
    }
    
    currentPosition = new Position(this.startPosition.left, this.startPosition.top);

    _prepareBox(mouseEvent);
    _setBounds();
    
    final PwtDragEvent takeOffEvent = new PwtDragEvent(this);
    this._dragTakeoffController.add(takeOffEvent);
    if(takeOffEvent.defaultPrevented) {
      return;
    }
    
    startDragMouse(mouseEvent);
    
    mouseEvent.preventDefault();
  }
  
  void startDragMouse(MouseEvent mouseEvent);
  
  void _prepareBox(MouseEvent mouseEvent);
  
  void _setBounds() {
    if (this._options.container != null) {
      this._bounds = this._options.container.innerBounds(this.box);
      
      if (_options.step._x != 1) {
        this._bounds._left -= (this._bounds._left - this.startPosition.x) % _options.step._x;
        this._bounds._right -= (this._bounds._right - this.startPosition.x) % _options.step._x;
      }
      
      if (_options.step._y != 1) {
        this._bounds._top -= (this._bounds._top - this.startPosition.y) % _options.step._y;
        this._bounds._bottom -= (this._bounds._bottom - this.startPosition.y) % _options.step._y;
      }
    } else {
      this._bounds = null;
    }
  }
  
  bool _startDragging() {
    // Fire Drag
    final PwtDragEvent event = new PwtDragEvent(this);
    this._dragDragController.add(event);
    if (event._defaultPrevented) {
      return false;
    }
    
    if (this._dragging == _DragState.DRAGGING) {
      _endDrag();
      return false;
    } else if (this._dragging != _DragState.READY) {
      return false;
    }
    
    this._dragging = _DragState.DRAGGING;
    
    return true;
  }
  
  void _addDocumentListeners(void onMouseMove(Event event), void onMouseUp(Event event)) {
    _listeners.add(document.onSelectStart.listen((Event e) => e.preventDefault()));
    _listeners.add(document.onDragStart.listen((Event e) => e.preventDefault()));
    _listeners.add(document.onMouseDown.listen((Event e) => e.preventDefault()));
    _listeners.add(document.onMouseMove.listen(onMouseMove));
    _listeners.add(document.onMouseUp.listen(onMouseUp));
  }
  
  void _dragMouse(MouseEvent mouseEvent) {
    //print(mouseEvent.pageX);
    final Position position = new Position(0, 0);
    
    _setPositionWithAxis(mouseEvent, position);
    _setPositionWithStep(position);
    _setPositionWithBounds(position);
    _setNewPosition(position);
    
    dragMouse(mouseEvent);
    
    mouseEvent.preventDefault();
  }
  
  void dragMouse(MouseEvent mouseEvent);
  
  void _setPositionWithAxis(MouseEvent mouseEvent, final Position position) {
    if (this._options.axis == Axis.X_AXIS) {
      position.top = this.startPosition.top;
      position.left = this.startPosition.x + mouseEvent.pageX - this.mouseStart.x;
    } else if (this._options.axis == Axis.Y_AXIS) {
      position.top = this.startPosition.top + mouseEvent.pageY - this.mouseStart.y;
      position.left = this.startPosition.x;
    } else {
      position.top = this.startPosition.top + mouseEvent.pageY - this.mouseStart.y;
      position.left = this.startPosition.left + mouseEvent.pageX - this.mouseStart.x;
    }
  }
  
  void _setPositionWithStep(final Position position) {
    if (_options.step._x != 1) {
      position.left = round((position.left - this.startPosition.left) / _options.step._x) 
                      * _options.step._x + this.startPosition.left;
    }
    if (_options.step._y != 1) {
      position.top = round((position.top - this.startPosition.top) / _options.step._y) 
                      * _options.step._y + this.startPosition.top;
    }
  }
  
  void _setPositionWithBounds(final Position position) {
    if (this._bounds != null) {
      // only apply bounds on the axis we're using
      if (this._options.axis != Axis.Y_AXIS) {
        if (position.left < this._bounds.left) {
          position.left = this._bounds.left;
        } else if (!this._options.onlyUpperLimits && position.left > this._bounds.right) {
          position.left = this._bounds.right;
        }
      }
      
      if (this._options.axis != Axis.X_AXIS) {
        if (position.top < this._bounds.top) {
          position.top = this._bounds.top;
        } else if (!this._options.onlyUpperLimits && position.top > this._bounds.bottom) {
          position.top = this._bounds.bottom;
        }
      }
    }
  }
  
  void _setNewPosition(final Position position) {
    //print(position.left - currentPosition.left);
    
    this.deltaPosition = new Position(position.left - currentPosition.left, position.top - currentPosition.top);
    this._dragMoveController.add(new PwtDragEvent(this));
    this.currentPosition = new Position(position.left, position.top);
  }

  void _releaseElement(MouseEvent mouseEvent) {
    _releaseDragging();
    _removeDocumentListeners();
    
    final PwtDragEvent event = new PwtDragEvent(this);
    this._dragDropController.add(event);
    if (event.defaultPrevented) {
      return;
    }
    
    _endDrag();
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
  
  void _endDrag(){
    _endDragging();

    this._dragAfterDropController.add(new PwtDragEvent(this));
  }
  
  void _endDragging() {
    if (this._dragging != _DragState.END) {
      return;
    }

    this._dragging = _DragState.READY;
  }
}

class DraggablePoint extends _DragCore {
  
  ExtElement point;
  CursorPosition cursorPosition;
  Function cursorOffset;
  
  DraggablePoint(var element, var point, [CursorPosition cursorPosition]) : 
    super(element, new PwtDragCoreOptions.map({'cursorAsOrigin':true})) {
    this.point = getExtElement(point);
    
    if (cursorPosition != null) {
      this.cursorPosition = cursorPosition;
    } else {
      this.cursorPosition = CursorPosition.CENTER;
    }
  }
  
  void startDragMouse(MouseEvent mouseEvent) {
    _addDocumentListeners(this._dragMouse, this._releaseElement);
  }
  
  void _prepareBox(MouseEvent mouseEvent){
    if (!point.isInDom()) {
      box.insertAdjacentElement('afterEnd', point.element);
    }
  
    switch(cursorPosition) {
      case CursorPosition.CENTER: 
        cursorOffset = _cursorOffsetCenter;
        break;
      case CursorPosition.N: 
        cursorOffset = _cursorOffsetN;
        break; 
      case CursorPosition.NE: 
        cursorOffset = _cursorOffsetNE;
        break; 
      case CursorPosition.E: 
        cursorOffset = _cursorOffsetE;
        break; 
      case CursorPosition.SE: 
        cursorOffset = _cursorOffsetSE;
        break;
      case CursorPosition.S: 
        cursorOffset = _cursorOffsetS;
        break;
      case CursorPosition.SW: 
        cursorOffset = _cursorOffsetSW;
        break;
      case CursorPosition.W: 
        cursorOffset = _cursorOffsetW;
        break;
      case CursorPosition.NW: 
        cursorOffset = _cursorOffsetNW;
        break;  
    }

    final Point offset = cursorOffset();
    
    point.style.top = '${currentPosition.top - offset.y}px';
    point.style.left = '${currentPosition.left - offset.x}px';
  }
  
  Point _cursorOffsetCenter() => new Point(point.widthMargin()~/2, point.heightMargin()~/2);
  Point _cursorOffsetN() => new Point(point.widthMargin()~/2, 0 + point.val('margin-top'));
  Point _cursorOffsetNE() => new Point(point.widthMargin() + point.val('margin-left'), 0 + point.val('margin-top'));
  Point _cursorOffsetE() => new Point(point.widthMargin() - point.val('margin-left'), point.widthMargin()~/2);
  Point _cursorOffsetSE() => new Point(point.widthMargin() - point.val('margin-left'), point.heightMargin() - point.val('margin-top'));
  Point _cursorOffsetS() => new Point(point.widthMargin()~/2, point.heightMargin() - point.val('margin-top'));
  Point _cursorOffsetSW() => new Point(0 + point.val('margin-left'), point.heightMargin() - point.val('margin-top'));
  Point _cursorOffsetW() => new Point(0 + point.val('margin-left'), point.heightMargin()~/2);
  Point _cursorOffsetNW() => new Point(0 + point.val('margin-left'), 0 + point.val('margin-top'));
  
  void dragMouse(MouseEvent mouseEvent) {
    final Point offset = cursorOffset();
    
    point.style.top = '${currentPosition.top - offset.y}px';
    point.style.left = '${currentPosition.left - offset.x}px';
  }
  
  void _endDrag(){
    _endDragging();

    this._dragAfterDropController.add(new PwtDragEvent(this));
    
    point.remove();
  }
}

class DraggableShadow extends _DragCore {
  
  ExtElement shadow;
  ExtElement model;
  bool outsideBorder;
  
  DraggableShadow(var element, [var model, PwtDragCoreOptions options]) : 
      super(element, options != null ? options : new PwtDragCoreOptions.map({'cursorAsOrigin':false})) {
    model = model != null ? model : element;
    this.model = getExtElement(model);
    outsideBorder = true;
  }
  
  void startDragMouse(MouseEvent mouseEvent) {
    _addDocumentListeners(this._dragMouse, this._releaseElement);
  }
  
  void _prepareBox(MouseEvent mouseEvent){
    final Element shadow = _createPlaceholderElement(model.element);
    shadow.style.border = '5px dashed blue';
    shadow.style.position = 'absolute';
    shadow.style.setProperty('z-index', '10000');
    model.insertAdjacentElement('afterEnd', shadow);
    
    this.shadow = new ExtElement(shadow);
    
    int newTop;
    int newLeft;
    int height;
    int width;
    final String position = model.element.getComputedStyle().position;
    final Position _modelPosition = model.position();
    newLeft = _modelPosition.x;
    newTop = _modelPosition.y;
    
    if (outsideBorder) {
      newLeft -= this.shadow.val('border-left-width');
      newTop -= this.shadow.val('border-top-width');
      height = model.heightBorder();
      width = model.widthBorder();
    } else {
      height = model.heightPadding();
      width = model.widthPadding();
    }

    shadow.style.setProperty('left', '${newLeft}px');
    shadow.style.setProperty('top', '${newTop}px');
    shadow.style.height = '${height}px';
    shadow.style.width = '${width}px';
    copyMargins(model.element, shadow);
  }
  
  void dragMouse(MouseEvent mouseEvent) {
    shadow.style.height = '${shadow.height + deltaPosition.top}px';
    shadow.style.width = '${shadow.width + deltaPosition.left}px';
  }
  
  void _endDrag(){
    _endDragging();

    this._dragAfterDropController.add(new PwtDragEvent(this));
    
    shadow.remove();
  }
}
