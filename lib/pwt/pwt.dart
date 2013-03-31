library pwt;

import 'dart:html';
import 'dart:math';
import '../animation/pwt_animation.dart';
import '../css/pwt_css.dart' as cssLib;
import '../dnd/pwt_dnd.dart';
import '../utils/pwt_utils.dart';

/**
 * 
 */
PwtElement $(dynamic selector) {
  
  if (selector is String) {
    final List<Element> elements = queryAll(selector); 
    
    if (elements == null || elements.isEmpty) {
      return null;
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
  int _logicalBottom;
  String _initialPosition;
  
  ExtElement(Element this._element) {
    _initialPosition = this._element.getComputedStyle().position;
  }
  
  Element get element => _element;
  String get initialPosition => _initialPosition;
  
  bool hasClass(final String className) => cssLib.hasClass(this._element, className);
  void addClasses(final String classesName) => cssLib.addClass(this._element, classesName);
  void removeClasses([final String classesName]) => cssLib.removeClass(this._element, classesName);
  void toggleClasses(final String classesName) => cssLib.toggleClass(this._element, classesName);
  
  bool isVisible() => cssLib.isVisible(this._element);
  bool isDisplayed() => cssLib.isDisplayed(this._element);
  bool isInDom() => cssLib.isInDom(this._element);
  void show({bool useVisibility:false}) => cssLib.show(this._element, useVisibility:useVisibility);
  void hide({bool useVisibility:false})=> cssLib.hide(this._element, useVisibility:useVisibility);
  void toggle({bool useVisibility:false})=> cssLib.toggle(this._element, useVisibility:useVisibility);
  
  int get height => cssLib.height(this._element);
  int get width => cssLib.width(this._element);

  void css(final Map properties) => cssLib.setCss(this._element, properties);

  /**
   * Get the top & left position of an element relative to its positioned parent
   * 
   * This is useful if you want to make a position:static element position:absolute and retain the original position of the element
   */
  cssLib.Position position() => cssLib.position(this._element);
  
  /**
   * Gets the offset from the top left of the document.
   */
  cssLib.Offset offset() => cssLib.offset(this._element);
  
  /**
   * Get integer value of a property or 0;
   */
  int val(String propertyName) => cssLib.val(this._element, propertyName);
  
  /**
   * This gets what CSS 'top' would be if the element were position "absolute"
   */
  int offsetTop() => cssLib.offsetTop(this._element);
  
  /**
   * This gets what CSS 'left' would be if the element were position "absolute"
   */
  int offsetLeft() => cssLib.offsetLeft(this._element);
  
  /**
   * Get the width of the element padding included.
   */
  int widthPadding() => cssLib.widthPadding(this._element);
  
  /**
   * Get the height of the element padding included
   */
  int heightPadding() => cssLib.heightPadding(this._element);
  
  /**
   * Get the width of the element from the left edge of the left border to the right edge of the right border.
   */
  int widthBorder() => cssLib.widthBorder(this._element);
  
  /**
   * Get the height of an element from the top edge of the top border to the bottom edge of the bottom border.
   */
  int heightBorder() {
    if (this._logicalBottom != null) {
      return this._logicalBottom - this.offsetTop();
    }
    
    return cssLib.heightBorder(this._element);
  }
  
  /**
   * Get the width of the element in including margin, borders and padding.
   */
  int widthMargin() => cssLib.widthMargin(this._element);
  
  /**
   * Get the height of the element in including margin, borders and padding.
   */
  int heightMargin() {
    return this.heightBorder() + this.val('margin-top') + this.val('margin-bottom');
  }
  
  /**
   * Get the offset of the left edge of the content of the box (i.e. excluding margin, border and padding).
   */
  int innerOffsetLeft() => cssLib.innerOffsetLeft(this._element);
  
  /**
   * Get the offset of the top edge of the content of the box (i.e. excluding margin, border and padding).
   */
  int innerOffsetTop() => cssLib.innerOffsetTop(this._element);
  
  /**
   * Get the number of pixels from the top of nearest element with absolute, relative or fixed position to the top of the page.
   */
  int offsetParentPageTop() => cssLib.offsetParentPageTop(this._element);
  
  /**
   * Get the combined width of the horizontal margins, borders and paddings.
   */
  int surroundWidth() => cssLib.surroundWidth(this._element);
  
  /**
   * Get the combined height of the horizontal margins, borders and paddings.
   */
  int surroundHeight() => cssLib.surroundHeight(this._element);
  
  /**
   * Get the the bounds for the left and top css properties of a child box to
   *   ensure that it stays within this element.
   */
  innerBounds(ExtElement childBox) {
    int top;
    int left;
    
    if (_initialPosition != 'static') {
      top = left = 0;
    } else {
      top = this.innerOffsetTop();
      left = this.innerOffsetLeft();
      
    }
    
    return new cssLib.Bounds(top, 
                      left, 
                      top + this.heightPadding() - childBox.heightMargin(),
                      left + this.widthPadding() - childBox.widthMargin());
  }
  
  /**
   * Get the top, right, bottom and left offsets of the outside edge of the border of the box.
   */
  cssLib.Bounds outerBounds () {
    final cssLib.Offset os = cssLib.offset(this._element);

    return new cssLib.Bounds(os.top, 
                      os.left, 
                      os.top + this.heightBorder(),
                      os.left + this.widthBorder()); 
  }
  
  /**
   * Get the intersection of this box with another box.
   * 
   * [box] A Box object to test for intersection with the current box.
   * 
   * [touches] If true, then the boxes don't have to intersect but can merely touch.
   * 
   * Returns:
   * An integer number of square pixels that the the outside of the
   * edge of the border of this box intersects with that of the passed
   * in box.
   */
  int intersectSize(ExtElement box, bool touches) {
    final cssLib.Bounds a = this.outerBounds();
    final cssLib.Bounds b = box.outerBounds();

    if (touches) {
      a.right++;
      a.bottom++;
      b.right++;
      b.bottom++;
    }
    
    int height;
    
    if (a.bottom < b.top || a.top > b.bottom) {
      height = 0;
    } else {
      if (a.top < b.top) {
        if (a.bottom < b.bottom) {
          height = a.bottom - b.top;
        } else {
          height = b.bottom - b.top;
        }
      } else {
        if (a.bottom > b.bottom) {
          height = b.bottom - a.top;
        } else {
          height = a.bottom - a.top;
        }
      }
    }
    
    int width;
    if (a.right < b.left || a.left > b.right) {
      width = 0;
    } else {
      if (a.left < b.left) {
        if (a.right < b.right) {
          width = a.right - b.left;
        } else {
          width = b.right - b.left;
        }
      } else {
        if (b.right < a.right) {
          width = b.right - a.left;
        } else {
          width = a.right - a.left; 
        }
      }
    }
    
    return height * width;
        /*
        (
            a.bottom < b.top ? 0 :
            b.bottom < a.top ? 0 :
            a.top < b.top ? (a.bottom < b.bottom ? a.bottom - b.top : b.bottom - b.top) :
            b.bottom < a.bottom ? b.bottom - a.top : a.bottom - a.top
        ) * (
            a.right < b.left ? 0 :
            b.right < a.left ? 0 :
            a.left < b.left? (a.right < b.right ? a.right - b.left : b.right - b.left) :
            b.right < a.right ? b.right - a.left : a.right - a.left
    );*/
  }
  
  /**
   * Check if a box is contained within the current box.
   * 
   * [box] The box to test.
   */
  bool contains(ExtElement box) {
    final cssLib.Bounds bounds = this.innerBounds(box);
    final cssLib.Offset offset = box.position();

    return offset.y >= bounds.top
           && offset.x >= bounds.left
           && offset.y <= bounds.bottom
           && offset.x <= bounds.right;
  }
  
  /**
   * Check if the point is inside the current box.
   * 
   * [point] The point to check
   */
  bool containsPoint(cssLib.Point point) {
    final cssLib.Offset elementOffset = this.offset();

    return point.x >= elementOffset.left
        && point.y >= elementOffset.top
        && point.x <= elementOffset.left + this.widthBorder()
        && point.y <= elementOffset.top  + this.heightBorder();
  }
  
  /**
   * Set the logical value for the position of the bottom of the border (offsetTop + offsetHeight).
   * 
   * [bottom] The value to use for the bottom of the box.
   */
  void setLogicalBottom (int bottom) {
    this._logicalBottom = bottom;
  }
  
  /**
   * Size and position a placeholder/drop indicator element to match that of the element.
   * 
   * [placeholderElement] The element that will be sized.
   * 
   * [startLeft] The original left position of the element.
   * 
   * [startTop] The original top position of the element.
   * 
   * [position] The value for the placeholder's CSS position. Defaults to the position of this element.
   */
  void sizePlaceholder(Element placeholderElement, int startLeft, int startTop, [String position]) {
    final ExtElement placeholderBox = new ExtElement(placeholderElement);
    
    if (position == null) {
      position = this._element.getComputedStyle().getPropertyValue('position');
    }
    
    //placeholderElement.style.setProperty('display', 'none');
    
    this._element.insertAdjacentElement('afterEnd', placeholderElement);
    
    int width = this._element.offsetWidth - placeholderBox.surroundWidth();
    int height = this._element.offsetHeight - placeholderBox.surroundHeight();
        
    placeholderElement.style.setProperty('width', '${width}px');
    placeholderElement.style.setProperty('height', '${height}px');
    
    // copy margin values
    cssLib.copyMargins(this._element, placeholderElement);
    
    placeholderElement.remove();
    
    //if (placeholderElement.tagName != 'LI') {
    //  placeholderElement.style.setProperty('display', 'block');  
    //} else {
    //  placeholderElement.style.setProperty('display', 'inline');
    //}
    
    if (position != 'static') {
      placeholderElement.style.setProperty('left', '${startLeft}px');
      placeholderElement.style.setProperty('top', '${startTop}px');
    }
    
    placeholderElement.style.setProperty('position', position);
  }

  Draggable draggable() => new Draggable(this._element);
  
  DragNDrop dnd(List<dynamic> dropTargets) => new DragNDrop(this._element, dropTargets);
  
  DropTarget asDropTarget() => new DropTarget(this._element);
  
  void addTo(Element element, [String where = 'afterEnd']) {
    element.insertAdjacentElement(where, this.element);
  }
  
  dynamic noSuchMethod(InvocationMirror invocation) {
    return invocation.invokeOn(this._element);
  }
}

ExtElement getExtElement(var element) {
  if (element is String) {
    return $(element);
  } else if (element is Element) {
    return new ExtElement(element);
  } else if (element is ElementList) {
    return new ExtElement(element.elements[0]);
  } else if (element is ExtElement) {
    return element;
  }

  return null;
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
  int get width => cssLib.width(this.element.first);
  
  void css(Map properties) => cssLib.setCssList(this.element, properties);
  
  List<Element> get elements => _elements;
  
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