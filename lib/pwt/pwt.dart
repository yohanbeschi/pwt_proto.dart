library pwt;

import 'dart:html';
import 'dart:math';
import '../animation/pwt_animation.dart';
import '../css/pwt_css.dart' as cssLib;
import '../utils/pwt_utils.dart';

/**
 * 
 */
PwtElement $(dynamic selector) {
  
  if (selector is String) {
    final List<Element> elements = queryAll(selector); 
    
    if (elements == null || elements.isEmpty) {
      throw new NoSuchElementError();
    } else if (elements.length == 1) {
      return new ExtElement(elements[0]);
    } else {
      return new ElementList(elements);
    }
  } else if (selector is HtmlDocument) {
    return new ExtDocument(selector);
  } else if (selector is Window) {
    return new ExtWindow(selector);
  }
}

class NoSuchElementError {}

/**
 * 
 */
abstract class PwtElement {
  bool hasClass(final String className);
  void addClasses(final String classesName);
  void removeClasses([final String classesName]);
  void toggleClasses(final String classesName);
  bool isVisible();
  bool isDisplayed();
  void show({bool useVisibility:false});
  void hide({bool useVisibility:false});
  void toggle({bool useVisibility:false});
  
  int get height;
  int get width;

  void css(Map properties);

  dynamic noSuchMethod(InvocationMirror invocation);
}

/**
 * 
 */
abstract class ExtNoElement implements PwtElement {
  bool hasClass(final String className) => false;
  void addClasses(final String classesName){}
  void removeClasses([final String classesName]){}
  void toggleClasses(final String classesName){}
  bool isVisible() => true;
  bool isDisplayed() => true;
  void show({bool useVisibility:false}){}
  void hide({bool useVisibility:false}){}
  void toggle({bool useVisibility:false}){}
  
  void css(Map properties){}
}

/**
 * 
 */
class ExtElement implements PwtElement {
  final Element _element;
  
  ExtElement(this._element);
  
  bool hasClass(final String className) => cssLib.hasClass(this._element, className);
  void addClasses(final String classesName) => cssLib.addClass(this._element, classesName);
  void removeClasses([final String classesName]) => cssLib.removeClass(this._element, classesName);
  void toggleClasses(final String classesName) => cssLib.toggleClass(this._element, classesName);
  
  bool isVisible() => cssLib.isVisible(this._element);
  bool isDisplayed() => cssLib.isDisplayed(this._element);
  void show({bool useVisibility:false}) => cssLib.show(this._element, useVisibility:useVisibility);
  void hide({bool useVisibility:false})=> cssLib.hide(this._element, useVisibility:useVisibility);
  void toggle({bool useVisibility:false})=> cssLib.toggle(this._element, useVisibility:useVisibility);
  
  int get height => cssLib.height(this._element);
  int get width => cssLib.width(this._element);

  void css(final Map properties) => cssLib.setCss(this._element, properties);
  
  dynamic noSuchMethod(InvocationMirror invocation) {
    return invocation.invokeOn(this._element);
  }
}

/**
 * 
 */
class ElementList implements PwtElement {
  final List<Element> _elements;
  
  ElementList(this._elements);

  bool hasClass(final String className) => cssLib.hasClassList(this._elements, className);
  void addClasses(final String classesName) => cssLib.addClassList(this._elements, classesName);
  void removeClasses([final String classesName]) => cssLib.removeClassList(this._elements, classesName);
  void toggleClasses(final String classesName) => cssLib.toggleClassList(this._elements, classesName);
  
  bool isVisible() => cssLib.isVisible(this._elements.first);
  bool isDisplayed() => cssLib.isDisplayed(this._elements.first);
  void show({bool useVisibility:false}) => cssLib.show(this._elements.first, useVisibility:useVisibility);
  void hide({bool useVisibility:false})=> cssLib.hide(this._elements.first, useVisibility:useVisibility);
  void toggle({bool useVisibility:false})=> cssLib.toggle(this._elements.first, useVisibility:useVisibility);
  
  int get height => cssLib.height(this._elements.first);
  int get width => cssLib.width(this._element.first);
  
  void css(Map properties) => cssLib.setCssList(this._element, properties);
  
  dynamic noSuchMethod(InvocationMirror invocation) {
    final Object obj = invocation.invokeOn(this._elements);
    if (obj is Element) {
      return new ExtElement(obj);
    } else {
      return obj;
    }
  }
}

/**
 * 
 */
class ExtDocument extends ExtNoElement implements PwtElement {
  HtmlDocument _document;
  
  ExtDocument(this._document);
  
  int get height {
    final Element doc = _document.documentElement;
    final int v1 = _document.body.scrollHeight;
    final int v2 = doc.scrollHeight;
    final int v3 = _document.body.offsetHeight;
    final int v4 = doc.offsetHeight;
    final int v5 = doc.clientHeight;
    
    return max(v5, max(v4, max(v3, max(v1, v2))));
  }
  
  int get width {
    final Element doc = _document.documentElement;
    final int v1 = _document.body.scrollWidth;
    final int v2 = doc.scrollWidth;
    final int v3 = _document.body.offsetWidth;
    final int v4 = doc.offsetWidth;
    final int v5 = doc.clientWidth;
    
    return max(v5, max(v4, max(v3, max(v1, v2))));
  }
}

/**
 * 
 */
class ExtWindow extends ExtNoElement implements PwtElement {
  Window _window;
  
  ExtWindow(this._window);
  
  int get height => _window.document.documentElement.clientHeight;
  int get width => _window.document.documentElement.clientWidth;
  
}