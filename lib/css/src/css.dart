part of pwt_proto;
 
//----------------------------------------------------------------------------------------------------------------------
// Has Class
//----------------------------------------------------------------------------------------------------------------------

bool hasClass(final Element element, final String className) {
  return element.classes.contains(className);
}

bool hasClassList(final List<Element> elements, final String className) {
  for (Element e in elements) {
    if (!hasClass(e, className)) {
      return false;
    }
  }
  
  return true;
}

//----------------------------------------------------------------------------------------------------------------------
// Add Classes
//----------------------------------------------------------------------------------------------------------------------

void addClass(final Element element, final String classesName) {
  _actOn(element, _actOnClassesOutside(classesName), _addClassInside);
}

void addClassList(final List<Element> elements, final String classesName) {
  _actOnList(elements, _actOnClassesOutside(classesName), _addClassInside);
}

void _addClassInside(final Element element, final List<String> classesName) {
  element.classes.addAll(classesName);
}

//----------------------------------------------------------------------------------------------------------------------
// Remove Classes
//----------------------------------------------------------------------------------------------------------------------
void removeClass(final Element element, final String classesName) {
  _actOn(element, _actOnClassesOutside(classesName), _removeClassInside);
}

void removeClassList(final List<Element> elements, final String classesName) {
  _actOnList(elements, _actOnClassesOutside(classesName), _removeClassInside);
}

void _removeClassInside(final Element element, final List<String> classesName) {
  if (classesName != null && !classesName.isEmpty) {
    element.classes.removeAll(classesName);
  } else {
    element.classes.clear();
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Toggle Classes
//----------------------------------------------------------------------------------------------------------------------
void toggleClass(final Element element, final String classesName) {
  _actOn(element, _actOnClassesOutside(classesName), _toggleClassInside);
}

void toggleClassList(final List<Element> elements, final String classesName) {
  _actOnList(elements, _actOnClassesOutside(classesName), _toggleClassInside);
}

void _toggleClassInside(final Element element, final List<String> classesName) {
  classesName.forEach((String className) {
    if (element.classes.contains(className)) {
      element.classes.remove(className);
    } else {
      element.classes.add(className);
    }
  });
}

//----------------------------------------------------------------------------------------------------------------------
// Utilities for classes
//----------------------------------------------------------------------------------------------------------------------

Function _actOnClassesOutside(final String classesName) {
  return (element, insideAction) {
    final Collection<String> classes = splitAtSpaces(classesName);
    insideAction(element, classes);
  };
}

//----------------------------------------------------------------------------------------------------------------------
// Set CSS
//----------------------------------------------------------------------------------------------------------------------

void setCss(final Element element, final Map<String, dynamic> properties) {
  _actOn(element, _setCssOutside(properties), _setCssInside);
}

void setCssList(final List<Element> elements, final Map properties) {
  _actOnList(elements, _setCssOutside(properties), _setCssInside);
}

void _setCssInside(final Element element, final String propertyName, final String value) {
  element.style.setProperty(uncamel(propertyName), value);
}

Function _setCssOutside(final Map<String, dynamic> properties) {
  return (element, insideAction) {
    for (String key in properties.keys) {
      final dynamic value = properties[key];
      final String propertyName = uncamel(key);
      insideAction(element, key, value);
    }
  };
}

//----------------------------------------------------------------------------------------------------------------------
// Visible / Displayed
//----------------------------------------------------------------------------------------------------------------------

bool isVisible(final Element element) {
  if (element.getComputedStyle().visibility != 'hidden') {
    return true;
  } else {
    return false;
  }
}

bool isDisplayed(final Element element) {
  if (element.getComputedStyle().display != 'none' && element.offsetHeight > 0) {
    return true;
  } else {
    return false;
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Show / Hide / Toggle
//----------------------------------------------------------------------------------------------------------------------

void show(final Element element, {bool useVisibility:false}) {
  if (useVisibility != null && useVisibility) {
    element.style.visibility = 'visible';
  } else {
    element.style.display = 'block';
  }
}

void hide(final Element element, {bool useVisibility:false}) {
  if (useVisibility != null && useVisibility) {
    element.style.visibility = 'hidden';
  } else {
    element.style.display = 'none';
  }
}

void toggle(final Element element, {bool useVisibility:false}) {
  if (useVisibility != null && useVisibility) {
    if (isVisible(element)) {
      hide(element, useVisibility:true);
    } else {
      show(element, useVisibility:true);
    }
  } else {
    if (isDisplayed(element) ) {
      hide(element, useVisibility:false);
    } else {
      show(element, useVisibility:false);
    }
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Dimensions
//----------------------------------------------------------------------------------------------------------------------
/**
 * Get integer value of a property or 0;
 */
int val(final Element element, final String propertyName) {
  return parseIntOrZero(element.getComputedStyle().getPropertyValue(propertyName));
}

int height(final Element element) {
  final CssStyleDeclaration css = element.getComputedStyle();

  final double bt = parseSizeValue(css.borderTopWidth);
  final double bb =  parseSizeValue(css.borderBottomWidth);
  final double pt = parseSizeValue(css.paddingTop);
  final double pb =  parseSizeValue(css.paddingBottom);
  final double border = bt + bb + pt + pb;
  return (element.offsetHeight - border).toInt();
}

int width(final Element element) {
  final CssStyleDeclaration css = element.getComputedStyle();
  final double bl = parseSizeValue(css.borderLeftWidth);
  final double br =  parseSizeValue(css.borderRightWidth);
  final double pl = parseSizeValue(css.paddingLeft);
  final double pr =  parseSizeValue(css.paddingRight);
  final double border = bl + br + pl + pr;
  return (element.offsetWidth - border).toInt();
}

Offset pageOffset(Element element, [bool skipFirstRelative = true]) {
  int x = 0;
  int y = 0;
  String position = skipFirstRelative ? '' : element.getComputedStyle().position;
  while(element != null && position != 'relative') {
    x += (element.offsetLeft - element.scrollLeft + element.clientLeft);
    y += (element.offsetTop - element.scrollTop + element.clientTop);
    element = element.offsetParent;
    
    if (element != null) {
      position = element.getComputedStyle().position;
    }
  }

  return new Offset(x, y);
}

/**
 * Gets the offset from the top left of the document.
 */
Offset offset(final Element element) {
  final ClientRect cr = element.getBoundingClientRect();
  return new Offset(cr.left.toInt() + window.document.documentElement.scrollLeft,
                    cr.top.toInt() + window.document.documentElement.scrollTop);
}

/**
 * Get the top & left position of an element relative to its positioned parent
 * 
 * This is useful if you want to make a position:static element position:absolute 
 * and retain the original position of the element
 */
Position position(final Element element) {
  final Element positionedParent = getPositionedParent(element);
  final bool hasPositionedParent = positionedParent != null;
  
  // element margins to deduct
  final int marginLeft = val(element, 'margin-left');
  final int marginTop = val(element, 'margin-top');
  
  // offset parent borders to deduct, set to zero if there's no positioned parent
  final int positionedParentBorderLeft = hasPositionedParent ? val(positionedParent, 'border-left-width') : 0;
  final int positionedParentBorderTop = hasPositionedParent ? val(positionedParent, 'border-top-width') : 0;
  
  // element offsets
  final Offset elementOffset = offset(element);
  final Offset positionedParentOffset = hasPositionedParent ? offset(positionedParent) : new Offset(0, 0);
  
  final int left = elementOffset.left - positionedParentOffset.left - marginLeft - positionedParentBorderLeft;
  final int top = elementOffset.top  - positionedParentOffset.top  - marginTop  - positionedParentBorderTop;

  return new Position(left, top);
}

/**
 * Get the 'real' positioned parent for an element, otherwise return null.
 */
Element getPositionedParent(final Element element) {
  Element offsetParent = element.offsetParent;
  
  // get the real positioned parent
  while (offsetParent != null && offsetParent.getComputedStyle().getPropertyValue('position') == "static") { 
    offsetParent = offsetParent.offsetParent;
  }
  
  // sometimes the <html> element doesn't appear in the offsetParent chain, even if it has position:relative
  if (offsetParent != null && document.documentElement.getComputedStyle().getPropertyValue('position') != "static") {
    offsetParent = document.documentElement;
  }
  
  return offsetParent;
}

/**
 * This gets what CSS 'top' would be if the element were position "absolute"
 */
int offsetTop(final Element element) {
  return position(element).top;
}

/**
 * This gets what CSS 'left' would be if the element were position "absolute"
 */
int offsetLeft(final Element element) {
  return position(element).left;
}

/**
 * Get the width of the element padding included.
 */
int widthPadding (final Element element) {
  return element.offsetWidth
      - val(element, 'border-left-width')
      - val(element, 'border-right-width');
}

/**
 * Get the height of the element padding included
 */
int heightPadding(final Element element) {
  return element.offsetHeight
      - val(element, 'border-top-width')
      - val(element, 'border-bottom-width');
}

/**
 * Get the width of the element from the left edge of the left border to the right edge of the right border.
 */
int widthBorder(final Element element) {
  return element.offsetWidth;
}

/**
 * Get the height of an element from the top edge of the top border to the bottom edge of the bottom border.
 */
int heightBorder(final Element element) {
  return element.offsetHeight;
}

/**
 * Get the width of the element in including margin, borders and padding.
 */
int widthMargin(final Element element) {
  return widthBorder(element) + val(element, 'margin-left') + val(element, 'margin-right');
}

/**
 * Get the height of the element in including margin, borders and padding.
 */
int heightMargin(final Element element) {
  return heightBorder(element) + val(element, 'margin-top') + val(element, 'margin-bottom');
}

/**
 * Get the offset of the left edge of the content of the box (i.e. excluding margin, border and padding).
 */
int innerOffsetLeft(final Element element) {
  return offsetLeft(element)
      + val(element, 'margin-left')
      + val(element, 'border-left-width')
      + val(element, 'padding-left');
}

/**
 * Get the offset of the top edge of the content of the box (i.e. excluding margin, border and padding).
 */
int innerOffsetTop(final Element element) {
  return offsetTop(element)
      + val(element, 'margin-top')
      + val(element, 'border-top-width')
      + val(element, 'padding-top');
}

/**
 * Get the number of pixels from the top of nearest element with absolute, relative or fixed position to the top of the page.
 */
int offsetParentPageTop(Element element) {
  while ((element = element.offsetParent) != null) {
    if (element.getComputedStyle().position != 'static' ) {
      break;
    }
  }
  
  return element != null ? offset(element).top : 0;
}

/**
 * Get the combined width of the horizontal margins, borders and paddings.
 */
int surroundWidth(final Element element) {
  return val(element, 'border-left-width')
      + val(element, 'padding-left')
      + val(element, 'padding-right')
      + val(element, 'border-right-width');
}

/**
 * Get the combined height of the horizontal margins, borders and paddings.
 */
int surroundHeight(final Element element) {
  return val(element, 'border-top-width')
      + val(element, 'padding-top')
      + val(element, 'padding-bottom')
      + val(element, 'border-bottom-width');
}

/**
 * Get the top, right, bottom and left offsets of the outside edge of the border of the box.
 */
Bounds outerBounds (final Element element) {
  final Offset os = offset(element);

  return new Bounds(os.top, 
      os.left, 
      os.top + widthBorder(element),
      os.left + heightBorder(element)); 
}

/**
 * Check if the point is inside the current box.
 * 
 * [point] The point to check
 */
bool containsPoint(final Element element, final Point point) {
  final Offset elementOffset = offset(element);
  return point.x >= elementOffset.left
      && point.y >= elementOffset.top
      && point.x <= elementOffset.left + widthBorder(element)
      && point.y <= elementOffset.top  + heightBorder(element);
}

/**
 * TODO: Doc
 */
void copyMargins(Element from, Element to) {
  to.style.setProperty('margin-top', from.getComputedStyle().getPropertyValue('margin-top'));
  to.style.setProperty('margin-left', from.getComputedStyle().getPropertyValue('margin-left'));
  to.style.setProperty('margin-bottom', from.getComputedStyle().getPropertyValue('margin-bottom'));
  to.style.setProperty('margin-right', from.getComputedStyle().getPropertyValue('margin-right'));
}

//----------------------------------------------------------------------------------------------------------------------
// Utilities for action on Element
//----------------------------------------------------------------------------------------------------------------------

void _actOn(final Element element, Function outsideAction, Function insideAction) {
  outsideAction(element, insideAction);
}

void _actOnList(final List<Element> elements, Function outsideAction, Function insideAction) {
  elements.forEach((element) => outsideAction(element, insideAction));
}