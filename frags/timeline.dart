import 'dart:async';
import 'dart:html';
import '../../lib/pwt/pwt.dart';
import '../../lib/animation/pwt_animation.dart';

void main() {
  final String name = 'timeline';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  
  // Listen Button
  $('#timeline1').onClick.listen((e) {
    final Animation anim = new Animation(query('#box06'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Animation anim2 = new Animation(query('#box16'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Timeline t = new Timeline([[anim],[anim2]], new TimelineOptions());
    t.start();
  });
  
  $('#timeline2').onClick.listen((e) {
    final Animation anim = new Animation(query('#box07'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Animation anim2 = new Animation(query('#box17'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Timeline t = new Timeline([[anim, anim2]], new TimelineOptions());
    t.start();
  });
  
  final Timeline t1 = buildWave('#waveContainer', 10);
  final Timeline t2 = buildWave('#waveContainer2', 100);
  StreamSubscription<MouseEvent> ssStart;
  StreamSubscription<MouseEvent> ssStop;
  StreamSubscription<MouseEvent> ssResume;
  
  
  ssStart = $('#start').onClick.listen((e) {
    $('#start').disabled = true;
    t1.start();
    t2.start();
    $('#stop').disabled = false;
    ssStart.cancel();
    ssStop.resume();
  });
  
  ssStop = $('#stop').onClick.listen((e) {
    $('#stop').disabled = true;
    t1.stop();
    t2.stop();
    $('#resume').disabled = false;
    ssStop.pause();
    ssResume.resume();
  });
  
  ssResume = $('#resume').onClick.listen((e) {
    $('#resume').disabled = true;
    t1.resume();
    t2.resume();
    $('#stop').disabled = false;
    ssStop.resume();
    ssResume.pause();
  });
  
  $('#stop').disabled = true;
  $('#resume').disabled = true;
  ssStop.pause();
  ssResume.pause();
}

buildWave(String container, int diff) {
  $(container).children.clear();
  // Build 100 divs
  for (int i = 0; i < 100; i++) {
    final DivElement element = new DivElement();
    element.style.left = '${7 * i}px';
    $(container).append(element);
  }
  
  // Build animations
  final List<Animation> waveDownAnims = new List();
  final List<Animation> waveUpAnims = new List();

  queryAll('${container} div').forEach((element) {
    final AnimationOptions optionsUp = new AnimationOptions(tween:easeBoth());
    final Animation animUp = animate(element, 1, {'top': {'from':'0px', 'to':'70px'}}, optionsUp);
    waveUpAnims.add(animUp);
    
    final AnimationOptions optionsDown = new AnimationOptions(tween:easeBoth());
    final Animation animDown = animate(element, 1, {'top': {'from':'70px', 'to':'0px'}}, optionsDown);
    waveDownAnims.add(animDown);
  });
  
  //create a channel for each div.
  //Each channel will have a difference pause at the start
  final List<List<dynamic>> channels = new List(waveUpAnims.length);
  for (int i = 0; i < waveUpAnims.length; i++) {
    channels[i] = [ (i / diff), waveDownAnims[i], waveUpAnims[i] ]; // 
  }

  //put it all together and play
  final TimelineOptions timeOpts = new TimelineOptions(loop:true);
  return new Timeline(channels, timeOpts);
}
