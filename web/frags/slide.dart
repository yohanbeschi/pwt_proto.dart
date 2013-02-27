import 'dart:html';
import '../../lib/pwt/pwt.dart';
import '../../lib/animation/pwt_animation.dart';

void main() {
  final String name = 'slide';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  
  // Listen Buttons
  Timeline down = null;
  Timeline up = null;
  $('#slideDown').onClick.listen((e) {
    if (up != null) {
      up.stop();
    }
    if (down == null || !down.playing) {
      down = slideDown(query('#box1'), 1, new SlideOptions());
    }
  });

  $('#slideUp').onClick.listen((e) {
    if (down != null) {
      down.stop();
    }
    if (up == null || !up.playing) {
      up = slideUp(query('#box1'), 1, new SlideOptions());
    }
  });
  
  Timeline toggle = null;
  $('#slideToggle').onClick.listen((e) {
    if (toggle == null || !toggle.playing) {
      toggle = slideToggle(query('#box2'));
    }
  });
}

