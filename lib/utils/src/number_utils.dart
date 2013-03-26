part of pwt_utils;

num inRange(num number, num min, [num max]) {
  if (min != null && number < min) {
    return min;
  }
  
  if (max != null && number > max) {
    return max;
  }
  
  return number;
}

int inRangeAsInt(num number, int min, [int max]) {
  return inRange(number, min, max).toInt();
}

num parseNumber(dynamic data) {
  if (data is num) {
    return data;
  } else if (data is String) {
    return double.parse(data);
  } else {
    return null;
  }
}

num parseOneDecimal(String s) {
  final double d = double.parse(s);
  final int i = (d * 10).toInt();
  return i / 10;
}

num toOneDecimal(double d) {
  final int i = (d * 10).toInt();
  return i / 10;
  //return d.toInt();
}

int round(num number) {
  return (number + 0.5).toInt();
}

num abs(num number) {
  return number > 0 ? number : -number;
}