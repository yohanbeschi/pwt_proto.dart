import 'dart:html';
import '../../lib/pwt/pwt.dart';
import '../../lib/animation/pwt_animation.dart';

void main() {
  final String name = 'animation';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Button
  $('#animate').onClick.listen((e) {
    final Animation anim = new Animation(query('#box05'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());
    anim.start();
    final Animation anim2 = new Animation(query('#box15'), 10,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());
    anim2.start();
  });
}

