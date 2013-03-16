part of pwt_proto;

class Point {
  int _x;
  int _y;
  
  Point(int this._x, int this._y);
  
  int get x => _x;
  int get y => _y;
}

class Offset extends Point {
  Offset(int left, int top) : super(left, top);
  
  int get left => this.x;
  int get top => this.y;
      set left(int left) => this._x = left;
      set top(int top) => this._y = top;
}

class Position extends Offset {
  Position(int left, int top) : super(left, top);
}

class Color {
  int _red;
  int _green;
  int _blue;
  double _opacity;
  
  Color(int red, int green, int blue) : this.rgba(red, green, blue, 1.0);
  
  Color.rgba(int this._red, int this._green, int this._blue, double this._opacity) {
    assertIntRange(0, 255, this._red); 
    assertIntRange(0, 255, this._green); 
    assertIntRange(0, 255, this._blue); 
    assertNumRange(0, 1, this._opacity);
  }
  
  int get red => this._red;
  int get green => this._green;
  int get blue => this._blue;
  double get opacity => this._opacity;
  
  String toString() => 'rgba($red,$green,$blue,$opacity)';
}

class Size {
  num _value;
  Unit _unit;
  
  Size(num this._value, Unit this._unit);
  
  num get value => this._value;
  Unit get unit => this._unit;
  
  String toString() => '$value$unit';
}

class DSize {
  Size _x;
  Size _y;
  
  DSize(Size this._x, Size this._y);
  

  Size get x => this._x;
  Size get y => this._y;
  
  String toString() => '$x $y';
}

class Bounds {
  int _top;
  int _left;
  int _bottom;
  int _right;
  
  Bounds(int this._top, int this._left, int this._bottom, int this._right);
  
  int get top => _top;
  int get left => _left;
  int get bottom => _bottom;
  int get right => _right;
  
      set top(int value) => _top = value;
      set left(int value) => _left = value;
      set bottom(int value) => _bottom = value;
      set right(int value) => _right = value;
      
  String toString() => '{Bounds -> top:${top}, left:${left}, bottom:${bottom}, right:${right}}';
}