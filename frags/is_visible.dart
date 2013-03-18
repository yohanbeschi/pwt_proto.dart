import 'dart:html';
import '../../lib/pwt/pwt.dart';

final Element yesElement = buildYesElement();
final Element noElement = buildNoElement();

void main() {
  final String name = 'isVisible';
  final int height = window.document.documentElement.scrollHeight;
  window.parent.postMessage('{"id":"$name", "height":"$height"}', '*');
  
  // Listen Buttons
  $('#isVisibleButton').onClick.listen((e) {
    final String selector = $('#selector').value;
    final bool isVisible = $('#sample $selector').isVisible();
    final PwtElement dom = $('#result');
    dom.children.clear();
    
    if (isVisible) {
      dom.append(yesElement);
    } else {
      dom.append(noElement);
    }
  });
  
  $('#isDisplayedButton').onClick.listen((e) {
    final String selector = $('#selector').value;
    final bool isDisplayed = $('#sample $selector').isDisplayed();
    final PwtElement dom = $('#result');
    dom.children.clear();
    
    if (isDisplayed) {
      dom.append(yesElement);
    } else {
      dom.append(noElement);
    }
  });
  
  $('#clear').onClick.listen((e) {
    $('#result').children.clear();
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


