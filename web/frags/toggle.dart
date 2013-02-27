import 'dart:html';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'toggle';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  
  // Listen Buttons
  $('#toggle1').onClick.listen((e) => $('#box1').toggle(useVisibility:true));

  $('#toggle2').onClick.listen((e) => $('#box2').toggle());
}

