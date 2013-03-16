import 'dart:html';
import 'dart:json';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'drop';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  //---- Ex1
  final ExtElement ee1 = $('#target1');
  final DropTarget dt1 = ee1.asDropTarget();
  dt1.onDrop((DropTargetEvent e) 
      => ee1.appendHtml("<p>I've been dropped on</p>")
  );

  $('#drag1').dnd([dt1]);
  
  //---- Ex2
  final ExtElement ee2 = $('#target2');
  final DropTarget dt2 = ee2.asDropTarget();
  dt2.dropZoneType = DropZoneType.SPACER;
  dt2.onDrop((_) => ee2.css({'backgroundColor': 'blue'}));

  $('#drag2').dnd([dt2])
    ..onDrop((DndEvent e) {
       if (e.drag.activeTarget != null) {
         e.drag.activeTarget.box.append(e.drag.box.element);
         e.preventDefault();
       }
    });
  
  //---- Ex3
  final ExtElement ee3A = $('#target3-contained');
  final DropTarget dt3A = ee3A.asDropTarget()
    ..tolerance = Tolerance.CONTAINED
    ..onDrop((_) {
      ee3A.appendHtml("<p>I've been dropped on</p>");
      ee3A.css({'opacity': '1'});
    })
    ..onActive((_) => ee3A.css({'border': '2px solid red'}))
    ..onInactive((_) => ee3A.css({'border': ''}))
    ..onEnter((_) => ee3A.css({'opacity': '0.7'}))
    ..onLeave((_) => ee3A.css({'opacity': '1'}));
  
  final ExtElement ee3B = $('#target3-pointer');
  final DropTarget dt3B = ee3B.asDropTarget()
    ..tolerance = Tolerance.CURSOR
    ..onDrop((_) {
      ee3B.appendHtml("<p>I've been dropped on</p>");
      ee3B.css({'opacity': '1'});
    })
    ..onActive((_) => ee3B.css({'border': '2px solid red'}))
    ..onInactive((_) => ee3B.css({'border': ''}))
    ..onEnter((_) => ee3B.css({'opacity': '0.7'}))
    ..onLeave((_) => ee3B.css({'opacity': '1'}));
  
  $('#drag3').dnd([dt3A, dt3B]);
  
  //---- Ex4
  final List<DropTarget> dts = 
    $('#ex4 td').elements.map(
        (e) =>
          new DropTarget(e)..dropZoneType = DropZoneType.SPACER
      ).toList();
  
  final ElementList ee4 = 
    $('.piece').elements.forEach(
      (e) => 
        new ExtElement(e).dnd(dts)
          ..onDrop(
            (DndEvent e) {
              if (e.drag.activeTarget != null) {
                e.drag.activeTarget.moveToPosition(e.drag);
                
                e.drag.activeTarget.disable();
                e.drag.disable();
              }
            }
          )
      );
}

