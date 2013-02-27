part of pwt_proto;

void colorToString1() {
  final Color color = new Color(250, 20, 10);
  assert('rgba(250,20,10,1.0)' == color.toString());
  
  print('colorToString1() executed');
}

void colorToString2() {
  final Color color = new Color.rgba(250, 20, 10, 0.5);
  assert('rgba(250,20,10,0.5)' == color.toString());
  
  print('colorToString1() executed');
}

void sizeToString1() {
  final Size size = new Size(150, Unit.PX);
  assert('150px' == size.toString());
  
  print('sizeToString1() executed');
}

void dSizeToString1() {
  final DSize dSize = new DSize(new Size(150, Unit.PX), new Size(200, Unit.PX));
  assert('150px 200px' == dSize.toString());
  
  print('dSizeToString1() executed');
}
