part of pwt_proto;

final RegExp UNITS = new RegExp(r'width|height|top$|bottom$|left$|right$|spacing$|indent$|font-size');
final RegExp NONE_NEGATIVE = new RegExp(r'width|height|padding|opacity');
final RegExp UNIT = new RegExp(r"([a-zA-Z]{2,3})$");
final RegExp SIZE = new RegExp(r"^([-]?\d+.?\d*)([a-zA-Z]{2,3}|[%]{1})$");
final RegExp DSIZE = new RegExp(r"^([-]?\d+.?\d*)([a-zA-Z]{2,3}|[%]{1})\s*([-]?\d+.?\d*)([a-zA-Z]{2,3}|[%]{1})$");
final RegExp RGB = new RegExp(r"^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$");
final RegExp RGBA = new RegExp(r"^rgba\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$");
final RegExp COLOR_HEX_SIX = new RegExp(r"^#([0-9a-f]{6})$", caseSensitive : true);
final RegExp COLOR_HEX_SIX_EXTRACT = new RegExp(r"([0-9a-fA-F]{2})");
final RegExp COLOR_HEX_THREE = new RegExp(r"^#([0-9a-fA-F]{3})$", caseSensitive : true);
final RegExp COLOR_HEX_THREE_EXTRACT = new RegExp(r"([0-9a-fA-F]{1})");


bool hasUnits(final String propertyName) {
  return UNITS.hasMatch(propertyName);
}

Unit parseUnit(final String s) {
  final Iterable<Match> matches = UNIT.allMatches(s);
  return Unit.enum(matches.elementAt(0).group(1));
}

double parseSizeValue(final String s) {
  final Iterable<Match> matches = SIZE.allMatches(s);
  return parseOneDecimal(matches.elementAt(0).group(1));
}

Size parseSize(final String s) {
  final Iterable<Match> matches = SIZE.allMatches(s);
  final double value = parseOneDecimal(matches.elementAt(0).group(1));
  final Unit unit = Unit.enum(matches.elementAt(0).group(2));
  return new Size(value, unit);
}

DSize parseDSize(final String s) {
  final Iterable<Match> matches = DSIZE.allMatches(s);
  final double valueX = parseOneDecimal(matches.elementAt(0).group(1));
  final Unit unitX = Unit.enum(matches.elementAt(0).group(2));
  final double valueY = parseOneDecimal(matches.elementAt(0).group(3));
  final Unit unitY = Unit.enum(matches.elementAt(0).group(4));
  return new DSize(new Size(valueX, unitX), new Size(valueY, unitY));
}

bool allowsNegative(String propertyName) {
  return !NONE_NEGATIVE.hasMatch(propertyName);
}

Color parseColor(String color) {
  if (RGB.hasMatch(color)) {
    return _colorFromRgb(color);
  } else if (RGBA.hasMatch(color)) {
    return _colorFromRgba(color);
  } else if (COLOR_HEX_SIX.hasMatch(color)) {
    return _colorFromHexSix(color);
  } else if (COLOR_HEX_THREE.hasMatch(color)) {
    return _colorFromHexThree(color);
  } else {
    return null;
  }
}

Color _colorFromRgb(String color) {
  final Iterable<Match> matches = RGB.allMatches(color);
  final int red = int.parse(matches.elementAt(0).group(1), radix:10);
  final int green = int.parse(matches.elementAt(0).group(2), radix:10);
  final int blue = int.parse(matches.elementAt(0).group(3), radix:10);
  return new Color(red, green, blue);
}

Color _colorFromRgba(String color) {
  final Iterable<Match> matches = RGBA.allMatches(color);
  final int red = int.parse(matches.elementAt(0).group(1), radix:10);
  final int green = int.parse(matches.elementAt(0).group(2), radix:10);
  final int blue = int.parse(matches.elementAt(0).group(3), radix:10);
  final double opacity = double.parse(matches.elementAt(0).group(4));
  return new Color.rgba(red, green, blue, opacity);
}

Color _colorFromHexSix(String color) {
  final Iterable<Match> matches = COLOR_HEX_SIX_EXTRACT.allMatches(color);
  final int red = int.parse(matches.elementAt(0).group(0), radix:16);
  final int green = int.parse(matches.elementAt(1).group(0), radix:16);
  final int blue = int.parse(matches.elementAt(2).group(0), radix:16);
  return new Color(red, green, blue);
}

Color _colorFromHexThree(String color) {
  final Iterable<Match> matches = COLOR_HEX_THREE_EXTRACT.allMatches(color);
  final String r = matches.elementAt(0).group(0);
  final String g = matches.elementAt(1).group(0);
  final String b = matches.elementAt(2).group(0);
  
  final int red = int.parse('$r$r', radix:16);
  final int green = int.parse('$g$g', radix:16);
  final int blue = int.parse('$b$b', radix:16);
  return new Color(red, green, blue);
}
