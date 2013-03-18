import 'dart:html';
import 'dart:json';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'css';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Button
  $('#setPropertiesButton').onClick.listen((e) {
    String properties = $('#properties').value;
    properties = properties.replaceAll("'", '"');
    $('#box').css(parse(properties));
  });
}

