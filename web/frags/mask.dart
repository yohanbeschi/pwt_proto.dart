import 'dart:html';
import 'dart:json';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';
import '../../lib/widgets/pwt_widgets.dart';

main() {
  final String name = 'mask';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  //---- Ex1
  final Mask mask = new Mask();
  mask.onClick((Event _) => mask.remove());    
  $('#showMask').onClick.listen((_) => mask.add());
  
  //---- Ex2
  final Mask mask2 = new Mask();
  mask2..backgroundColor = '#fff'
      ..opacity = 0.8
      ..onClick((Event _) => mask2.remove()); 
  $('#showMask2').onClick.listen((_) => mask2.add());
  
  //---- Ex3
  final Mask mask3 = new Mask();
  mask3..css({'background': '#fff url(../img/stripe.png)'}) 
      ..opacity = 0.8
      ..disableScroll = true
      ..onClick((Event _) => mask3.remove()); 
  $('#showMask3').onClick.listen((_) => mask3.add());
} 

