part of pwt_dnd;

/**
 * Create a placehoder for an element.
 * TODO: Doc
 * [element] is the element to 'clone'
 */
Element _createPlaceholderElement(Element element) {
  Element placeholder;
  
  if (element.tagName == 'LI') {
    placeholder = new LIElement();
    placeholder.style.setProperty('list-style-type', 'none');
  } else {
    placeholder = new DivElement();
  }

  return placeholder;
}