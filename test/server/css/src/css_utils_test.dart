part of pwt_proto;

void hasUnitsTest1() {
  final String s = 'height';
  final bool actual = hasUnits(s);
  assert(actual);
  
  print('hasUnitsTest1() executed');
}

void hasUnitsTest2() {
  final String s = 'margin-top';
  final bool actual = hasUnits(s);
  assert(actual);
  
  print('hasUnitsTest2() executed');
}

void hasUnitsTest3() {
  final String s = 'border-right-width';
  final bool actual = hasUnits(s);
  assert(actual);
  
  print('hasUnitsTest3() executed');
}

void hasUnitsTest4() {
  final String s = 'display';
  final bool actual = hasUnits(s);
  assert(!actual);
  
  print('hasUnitsTest4() executed');
}

void parseUnitTest1() {
  final String s = '10px';
  final Unit unit = parseUnit(s);
  assert(unit == Unit.PX);
  
  print('parseUnitTest1() executed');
}

void parseUnitTest2() {
  final String s = '10tt';
  bool exceptionRaised = false;
  
  try {
    parseUnit(s);
  } on NoneExistingUnit catch (e) {
    exceptionRaised = true;
  }

  assert(exceptionRaised);
  
  print('parseUnitTest2() executed');
}

void parseSizeTest1() {
  final String s = '10.5%';
  final Size size = parseSize(s);
  assert(size.value == 10.5);
  assert(size.unit == Unit.PCT);
  
  print('parseSizeTest1() executed');
}

void parseSizeTest2() {
  final String s = '-10px';
  final Size size = parseSize(s);
  assert(size.value == -10);
  assert(size.unit == Unit.PX);
  
  print('parseSizeTest2() executed');
}

void parseDSizeTest1() {
  final String s = '10.5px 20.4px';
  final DSize dSize = parseDSize(s);
  assert(dSize.x.value == 10.5);
  assert(dSize.x.unit == Unit.PX);
  assert(dSize.y.value == 20.4);
  assert(dSize.y.unit == Unit.PX);
  
  print('parseDSizeTest1() executed');
}

void parseDSizeTest2() {
  final String s = '-10px -20px';
  final DSize dSize = parseDSize(s);
  assert(dSize.x.value == -10);
  assert(dSize.x.unit == Unit.PX);
  assert(dSize.y.value == -20);
  assert(dSize.y.unit == Unit.PX);
  
  print('parseDSizeTest2() executed');
}

void allowsNegativeTest1() {
  final String s = 'height';
  final bool actual = allowsNegative(s);
  assert(!actual);
  
  print('allowsNegativeTest1() executed');
}

void allowsNegativeTest2() {
  final String s = 'left';
  final bool actual = allowsNegative(s);
  assert(actual);
  
  print('allowsNegativeTest2() executed');
}

void colorFromRgbTest1() {
  final Color color = _colorFromRgb('rgb(10, 35, 245)');
  assert(color.red == 10);
  assert(color.green == 35);
  assert(color.blue == 245);
  
  print('colorFromRgbTest1() executed');
}

void colorFromRgbTest2() {
  final Color color = _colorFromRgb('rgb(52,235,45)');
  assert(color.red == 52);
  assert(color.green == 235);
  assert(color.blue == 45);
  
  print('colorFromRgbTest2() executed');
}

void colorFromHexSixTest1() {
  final Color color = _colorFromHexSix('#fFfFFf');
  assert(color.red == 255);
  assert(color.green == 255);
  assert(color.blue == 255);
  
  print('colorFromHexSixTest1() executed');
}

void colorFromHexThreeTest1() {
  final Color color = _colorFromHexThree('#a1b');
  assert(color.red == 170);
  assert(color.green == 17);
  assert(color.blue == 187);
  
  print('colorFromHexThreeTest1() executed');
}

void colorFromHexThreeTest2() {
  final Color color = _colorFromHexThree('#FfF');
  assert(color.red == 255);
  assert(color.green == 255);
  assert(color.blue == 255);
  
  print('colorFromHexThreeTest2() executed');
}

void parseColorTest1() {
  final Color color = parseColor('rgb(10, 35, 245)');
  assert(color.red == 10);
  assert(color.green == 35);
  assert(color.blue == 245);
  
  print('parseColorTest1() executed');
}

void parseColorTest2() {
  final Color color = parseColor('#a1b');
  assert(color.red == 170);
  assert(color.green == 17);
  assert(color.blue == 187);
  
  print('parseColorTest2() executed');
}

void parseColorTest3() {
  final Color color = parseColor('#0f0f0f');
  assert(color.red == 15);
  assert(color.green == 15);
  assert(color.blue == 15);
  
  print('parseColorTest3() executed');
}