part of pwt_utils;

void isEmptyTest() {
  
}

void camelCaseTest1() {
  final String s = "border-bottom-style";
  final String actual = camelCase(s);
  assert('borderBottomStyle' == actual);
  
  print('camelCaseTest1() executed');
}

void camelCaseTest2() {
  final String s = "borderBottomStyle";
  final String actual = camelCase(s);
  assert('borderBottomStyle' == actual);
  
  print('camelCaseTest2() executed');
}

void uncamelTest1() {
  final String s = "borderBottomStyle";
  final String actual = uncamel(s);
  assert('border-bottom-style' == actual);
  
  print('uncamelTest1() executed');
}

void uncamelTest2() {
  final String s = "border-bottom-style";
  final String actual = uncamel(s);
  assert('border-bottom-style' == actual);
  
  print('uncamelTest2() executed');
}