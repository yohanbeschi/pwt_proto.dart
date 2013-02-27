part of pwt_utils;

void inRangeTest1() {
  num number = inRange(20, 0, 100);
  assert(20 == number);
  
  print('inRangeTest1() executed');
}

void inRangeTest2() {
  num number = inRange(20, 0);
  assert(20 == number);
  
  print('inRangeTest2() executed');
}

void inRangeTest3() {
  num number = inRange(20, 50);
  assert(50 == number);
  
  print('inRangeTest3() executed');
}

void inRangeTest4() {
  num number = inRange(120, 50, 100);
  assert(100 == number);

  print('inRangeTest4() executed');
}

void inRangeAsIntTest1() {
  final int number = inRangeAsInt(20.15, 0, 100);
  assert(20 == number);
  
  print('inRangeAsIntTest1() executed');
}

void inRangeAsIntTest2() {
  final int number = inRangeAsInt(20, 0, 100);
  assert(20 == number);
  
  print('inRangeAsIntTest2() executed');
}

void parseNumberTest1() {
  final num number = parseNumber('10');
  assert(10 == number);
  
  print('parseNumberTest1() executed');
}

void parseNumberTest2() {
  final num number = parseNumber(30.5);
  assert(30.5 == number);
  
  print('parseNumberTest2() executed');
}

void parseNumberTest3() {
  final num number = parseNumber(null);
  assert(null == number);
  
  print('parseNumberTest3() executed');
}

void parseOneDecimalTest1() {
  final double d = parseOneDecimal('12.03264212');
  assert(d == 12.0);
  
  print('parseOneDecimalTest1() executed');
}

void parseOneDecimalTest2() {
  final double d = parseOneDecimal('12');
  assert(d == 12.0);
  
  print('parseOneDecimalTest2() executed');
}

void parseOneDecimalTest3() {
  final double d = parseOneDecimal('12.4');
  assert(d == 12.4);
  
  print('parseOneDecimalTest3() executed');
}