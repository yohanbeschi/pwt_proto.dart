part of pwt_dnd;

class Step {
  int _x;
  int _y;
  
  Step.same(int xAndY) {
    this._x = xAndY;
    this._y = xAndY;
  }
  
  Step(int x, int y) {
    this._x = x;
    this._y = y;
  }
}