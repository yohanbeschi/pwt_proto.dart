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
// Height / Width
//----------------------------------------------------------------------------------------------------------------------

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

//----------------------------------------------------------------------------------------------------------------------
// Utilities for action on Element
//----------------------------------------------------------------------------------------------------------------------

void _actOn(final Element element, Function outsideAction, Function insideAction) {
  outsideAction(element, insideAction);
}

void _actOnList(final List<Element> elements, Function outsideAction, Function insideAction) {
  elements.forEach((element) => outsideAction(element, insideAction));
}