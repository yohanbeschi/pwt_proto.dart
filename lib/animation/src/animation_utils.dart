part of pwt_animation;

String buildNum(num value, num from, num to) {
  String string = (toOneDecimal((to - from) * value + from)).toString();
  //print(string);
  return string;
}

String buildColor(num value, Color from, Color to) {
  final int newRed = inRangeAsInt((to.red - from.red) * value + from.red, 0, 255);
  final int newGreen = inRangeAsInt((to.green - from.green) * value + from.green, 0, 255);
  final int newBlue = inRangeAsInt((to.blue - from.blue) * value + from.blue, 0, 255);
  final double newOpacity = inRange((to.opacity - from.opacity) * value + from.opacity, 0.0, 1.0);
  String string = new Color.rgba(newRed, newGreen, newBlue, newOpacity).toString();
  //print(string);
  return string;
}

String buildSize(num value, Size from, Size to) {
  final double newValue = (to.value - from.value) * value + from.value;
  String string = new Size(newValue.toInt(), from.unit).toString();
  //print(string);
  return string;
}

String buildSizeInRange(num value, Size from, Size to) {
  final double newValue = inRange((to.value - from.value) * value + from.value, 0.0);
  String string = new Size(toOneDecimal(newValue), from.unit).toString();
  //print(string);
  return string;
}

String buildDsize(num value, DSize from, DSize to) {
  final double newX = (to.x.value - from.x.value) * value + from.x.value;
  final double newY = (to.y.value - from.y.value) * value + from.y.value;
  final Size newSizeX = new Size(toOneDecimal(newY), from.x.unit);
  final Size newSizeY = new Size(toOneDecimal(newX), from.y.unit);
  
  String string = new DSize(newSizeX, newSizeY).toString();
  return string;
}

