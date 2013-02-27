import 'dart:html';
import '../../lib/pwt/pwt.dart';

void main() {
  final String name = 'addClasses';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Buttons
  $('#addClassesButton').onClick.listen((e) {
    final String selector = $('#selector').value;
    final String classesName = $('#class').value;
    $('#result $selector').addClasses(classesName);
  });
  
  $('#removeClassesButton').onClick.listen((e) {
    final String selector = $('#selector').value;
    final String classesName = $('#class').value;
    $('#result $selector').removeClasses(classesName);
  });
}

