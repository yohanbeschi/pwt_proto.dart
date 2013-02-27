import 'dart:html';
import '../../lib/pwt/pwt.dart';
import '../../lib/animation/pwt_animation.dart';

void main() {
  final String name = 'fade';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Buttons
  Timeline down = null;
  Timeline up = null;
  $('#fadeIn').onClick.listen((e) {
    fadeIn(query('#box1'), 1, new FadeOptions());
  });

  $('#fadeOut').onClick.listen((e) {
    fadeOut(query('#box1'), 1, new FadeOptions());
  });
}

