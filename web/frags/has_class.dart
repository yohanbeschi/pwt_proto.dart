import 'dart:html';
import '../../lib/pwt/pwt.dart';

final Element yesElement = buildYesElement();
final Element noElement = buildNoElement();

void main() {
  // Notify container
  final String name = 'hasClass';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Button
  $('#hasClassButton').onClick.listen((e) {
    final String selector = $('#selector').value;
    final String clazz = $('#class').value;
    final bool hasClass = $('#sample $selector').hasClass(clazz);
    final PwtElement dom = $('#result');
    dom.children.clear();
    
    if (hasClass) {
      dom.append(yesElement);
    } else {
      dom.append(noElement);
    }
  });
}

Element buildNoElement() {
  final DivElement element = new DivElement();
  element.text = 'NO';
  final CssStyleDeclaration css = element.style;
  css.color = 'red';
  css.fontSize = '32px';
  return element;
}

Element buildYesElement() {
  final DivElement element = new DivElement();
  element.text = 'YES';
  final CssStyleDeclaration css = element.style;
  css.color = 'green';
  css.fontSize = '32px';
  return element;
}


