import 'dart:html';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'toggleClasses';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Buttons
  $('#toggleClassesButton').onClick.listen((e) {
    final String selector = $('#selector').value;
    final String classesName = $('#class').value;
    $('#result $selector').toggleClasses(classesName);
  });
}

