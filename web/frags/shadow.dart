import 'dart:html';
import 'dart:json';
import '../../lib/css/pwt_css.dart';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'shadow';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  //---- Ex1
  Element element1 = new Element.tag('div');
  element1.style.position = 'absolute';
  element1.style.height = '20px';
  element1.style.width = '20px';
  element1.style.border = '1px solid #000';
  new DraggablePoint('#shadow1', element1);
  
  //---- Ex2
  new DraggableShadow('#shadow2');
}