import 'dart:html';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'showHide';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  
  // Listen Buttons
  $('#show1').onClick.listen((e) => $('#box1').show(useVisibility:true));
  
  $('#hide1').onClick.listen((e) => $('#box1').hide(useVisibility:true));
  
  $('#show2').onClick.listen((e) => $('#box2').show());
  
  $('#hide2').onClick.listen((e) => $('#box2').hide());
}

