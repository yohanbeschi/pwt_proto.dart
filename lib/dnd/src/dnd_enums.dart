part of pwt_dnd;

class PlaceholderType extends Enum {
  static const PlaceholderType SPACER = const PlaceholderType._internal('spacer');
  static const PlaceholderType CLONE = const PlaceholderType._internal('clone');
  static const PlaceholderType NONE = const PlaceholderType._internal('none');
  
  const PlaceholderType._internal(String name) : super(name);
}

class Axis extends Enum {
  static const Axis X_AXIS = const Axis._internal('x');
  static const Axis Y_AXIS = const Axis._internal('y');
  
  const Axis._internal(String name) : super(name);
}

class Tolerance extends Enum {
  static const Tolerance INTERSECT = const Tolerance._internal('intersect');
  static const Tolerance CONTAINED = const Tolerance._internal('contained');
  static const Tolerance CURSOR = const Tolerance._internal('cursor');
  
  const Tolerance._internal(String name) : super(name);
}

class DropZoneType extends Enum {
  static const DropZoneType SPACER = const DropZoneType._internal('spacer');
  static const DropZoneType CLASS = const DropZoneType._internal('class');
  static const DropZoneType NONE = const DropZoneType._internal('none');

  const DropZoneType._internal(String name) : super(name);
}

class _DragState extends Enum {
  static const _DragState READY = const _DragState._internal('ready');
  static const _DragState DRAGGING = const _DragState._internal('dragging');
  static const _DragState END = const _DragState._internal('end');
  
  const _DragState._internal(String name) : super(name);
}

class CursorPosition extends Enum {
  static const CursorPosition N = const CursorPosition._internal('n');
  static const CursorPosition NE = const CursorPosition._internal('ne');
  static const CursorPosition E = const CursorPosition._internal('e');
  static const CursorPosition SE = const CursorPosition._internal('se');
  static const CursorPosition S = const CursorPosition._internal('s');
  static const CursorPosition SW = const CursorPosition._internal('sw');
  static const CursorPosition W = const CursorPosition._internal('w');
  static const CursorPosition NW = const CursorPosition._internal('nw');
  static const CursorPosition CENTER = const CursorPosition._internal('center');
  
  const CursorPosition._internal(String name) : super(name);
}