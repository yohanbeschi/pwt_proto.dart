import 'dart:html';
import '../../../lib/css/pwt_css.dart';
import '../../../lib/pwt/pwt.dart';
import '../../../lib/dnd/pwt_dnd.dart';

void main() {
  final ExtElement model = $('#model');
  final Offset offset = model.offset();
  Position position = model.position();
  position = model.position();
  $('#offset').appendHtml('Offset(top: ${offset.top}, left: ${offset.left})<br>');
  $('#position').appendHtml('Position(top: ${position.top}, left: ${position.left})<br>');

  //final ExtElement el = $('#el');
  //model.style.setProperty('z-index', '500');
  //model.style.setProperty('position', 'absolute');
  //model.style.setProperty('left', '${position.x}px');
  //model.style.setProperty('top', '${position.y}px');
  
  //$('#model').onMouseDown.listen(startDragMouse);

  $('#model').draggable();
 
}

void startDragMouse(MouseEvent e) {
  Position position = $('#model').position();
  final Offset offset = $('#model').offset();
  $('#position').appendHtml('-Position(top: ${position.top}, left: ${position.left})<br>');
  $('#offset').appendHtml('Offset(top: ${offset.top}, left: ${offset.left})<br>');
}
