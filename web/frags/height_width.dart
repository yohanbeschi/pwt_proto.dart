import 'dart:html';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'heightWidth';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  
  // Listen Buttons
  $('#height').onClick.listen((e) {
    int height = $('#box').height;
    window.alert('Height: $height');
  });
  
  $('#width').onClick.listen((e) {
    int width = $('#box').width;
    window.alert('Width: $width');
  });
}

