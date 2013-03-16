import 'dart:html';
import 'dart:json';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'resizable';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  //---- Ex1
  new Resizable('#resizable1');
  
  //---- Ex2
  new Resizable('#resizable2', useShadow:true);
  
  //---- Ex3
  new Resizable('#resizable3', animate:true);
}

