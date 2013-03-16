import 'dart:html';
import 'dart:json';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'drag';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  $('#drag1').draggable();
  
  $('#drag2').draggable()
    ..placeholderType = PlaceholderType.SPACER
    ..placeholderClass = 'placeholder2';
  
  $('#drag3').draggable()
    ..placeholderType = PlaceholderType.CLONE;
  
  $('#drag4').draggable()
    ..container = '#container4';
  
  $('#drag5').draggable()
    ..handle = '#handle5';
  
  $('#drag6').draggable()
    ..container = '#ex6'
    ..axis = Axis.X_AXIS;
  
  //---- Resize
  final ExtElement ee7 = $('#container7');
  $('#resize-y').draggable()
    ..container = '#container7'
    ..enableOnlyUpperLimits()
    ..axis = Axis.Y_AXIS
    ..onMove((DragEvent d) 
       => ee7.style.height = '${ee7.height + d.drag.deltaPosition.top}px'
    )
    ..onDrop((_) {
      $('#resize-y').style.left = '';
      $('#resize-y').style.top = '';
    });
  
  $('#resize-x').draggable()
    ..container = '#container7'
    ..enableOnlyUpperLimits()
    ..axis = Axis.X_AXIS
    ..onMove((DragEvent d)
        => ee7.style.width = '${ee7.width + d.drag.deltaPosition.left}px'
    )
    ..onDrop((_) {
      $('#resize-x').style.left = '';
      $('#resize-x').style.top = '';
    });
  
  $('#resize-xy').draggable()
    ..container = '#container7'
    ..enableOnlyUpperLimits()
    ..onMove((DragEvent d) {
      ee7.style.height = '${ee7.height + d.drag.deltaPosition.top}px';
      ee7.style.width = '${ee7.width + d.drag.deltaPosition.left}px';
    })
    ..onDrop((_) {
      $('#resize-xy').style.left = '';
      $('#resize-xy').style.top = '';
    });
}

