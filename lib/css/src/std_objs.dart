part of pwt_proto;

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