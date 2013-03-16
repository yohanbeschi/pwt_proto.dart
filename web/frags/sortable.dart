import 'dart:html';
import 'dart:json';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';
import '../../lib/widgets/pwt_widgets.dart';

main() {
  final String name = 'sortable';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  //---- Ex1
  new Sortable(['#sortable1']);
  
  //---- Ex2
  final SortableOptions opts2 = new SortableOptions()
    ..container = '#sortable2'
    ..axis = Axis.Y_AXIS;
  new Sortable(['#sortable2'], opts2);
  
  //---- Ex3
  final ExtElement ee3 = $('#target3');
  final DropTarget dt3 = new DropTarget('#target3')
      ..tolerance = Tolerance.CONTAINED
      ..onDrop((_) {
        ee3.appendHtml("<p>I've been dropped on</p>");
        ee3.css({'opacity': '1'});
      })
      ..onActive((_) => ee3.css({'border': '2px solid red'}))
      ..onInactive((_) => ee3.css({'border': ''}))
      ..onEnter((_) => ee3.css({'opacity': '0.7'}))
      ..onLeave((_) => ee3.css({'opacity': '1'}));  
  
  
  final SortableOptions opts3 = new SortableOptions();
  new Sortable(['#sortable3', dt3], opts3);

  //---- Ex4  
  new Sortable(['#sortable4-1', '#sortable4-2']);
  
  //---- Ex5
  new Sortable(['#sortable5'], new SortableOptions()
    ..dropZoneClass = 'dropZone'
    ..handle = 'strong');
  
  //---- Ex6
  new Sortable(['#cols-example .col1', '#cols-example .col2', '#cols-example .col3'], new SortableOptions()
    ..dropZoneClass = 'dropZone'
    ..handle = 'strong');
} 

