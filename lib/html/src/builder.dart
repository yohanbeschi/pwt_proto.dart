part of pwt_html;

HtmlBuilder builder() => new HtmlBuilder();

Element element(String tagName, [Map attributes, String text]) {
  final Element element = new Element.tag(tagName);
  return e(element, attributes, text);
}

Element e(Element element, [Map attributes, String text]) {
  if (attributes != null) {
    for (String key in attributes.keys) {
      element.attributes[key] = attributes[key];
    }
  }
  
  if (text != null) {
    element.text = text;
  }
  
  return element;
}
  
class HtmlBuilder extends HtmlManager {
  
  Element div([Map attributes, String text]) {
    if (text == null) {
      open('div', attributes);
    } else {
      add('div', attributes, text);
    }
  }
  
  Element span([Map attributes, String text]) {
    if (text == null) {
      open('span', attributes);
    } else {
      add('span', attributes, text);
    }
  }
  
  Element ul([Map attributes]) => open('ul', attributes);
  Element li([Map attributes]) => open('li', attributes);
  Element input([Map attributes]) => add('input', attributes);
  Element select([Map attributes]) => open('select', attributes);
  Element option([Map attributes, String text]) => add('option', attributes, text);
  
  /**
   * Open a new tag.
   * [param] tagName
   * [param] attributes
   */
  Element open(final String tagName, [Map attributes, String text]) {
    final Element tag = element(tagName, attributes, text);
    super.openTag(tag);
    return tag;
  }
  
  /**
   * Add a new empty element.
   * Be careful!! An empty element can only be attached to a container tag.
   * [param] tagName
   * [param] attributes
   */
  Element add(final String tagName, [Map attributes, String text]) {
    final Element tag = element(tagName, attributes, text);
    super.addElement(tag);
    return tag;
  }

  void end() => super.closeTag();
  void endAll() => super.closeAllOpenedTags();
  
  void addTo(Element parent, [String where = 'afterEnd']) {
    if (this.content.length == 1) {
      parent.insertAdjacentElement(where, content[0]);
    } else {
      if (where == 'beforeBegin' || where == 'afterBegin') {
        for (int i = this.content.length - 1; i >= 0; i--) {
          parent.insertAdjacentElement(where, content[i]);
        }
      } else {
        for (Element e in this.content) {
          parent.insertAdjacentElement(where, e);
        }
      }
    }
  }
}

class HtmlManager {
  /**
   * List of all the root elements in the document<br>
   * 0 or 1 BlockTag and 0 or * Comment[s]
   */
  List<Element> content;
  
  /**
   * List of opened tags.
   */
  List<Element> openedElements;
  
  /**
   * Current element.
   */
  Element currentElement;
  
  HtmlManager() : this.content = new List(),
                  this.openedElements = new List();
  
  /**
   * Open a new tag.
   * @param tag is the new tag to start.
   */
  void openTag(final Element tag) {
    if (this.currentElement == null) {
      this.currentElement = tag;
      this.content.add(this.currentElement);
    } else {
      this.currentElement.append(tag);
      this.currentElement = tag;
    }
    
    // Add the current tag to the list of opened tags
    this.openedElements.add(this.currentElement);
  }

  /**
   * Close the last opened tag.
   */
  void closeTag() {
    // Remove the current tag from the opened list tags
    this.openedElements.removeLast();
    
    // The last element of the list of the opened tags becomes the current tag
    // If the list is empty, the current tag is null
    if (!this.openedElements.isEmpty) {
      this.currentElement = this.openedElements.last;
    } else {
      this.currentElement = null;
    }
  }
    
  /**
   * Close all opened tags.
   */
  void closeAllOpenedTags() {
    this.openedElements.clear();
  }
  
  String text(String text) => currentElement.text = text; 
    
  /**
   * Add an element to the current element.
   * [element] is any kind of object implementing Element.
   */
  void addElement(final Element element) {
    if (this.currentElement != null) {
      this.currentElement.append(element);
    } else {
      this.content.add(element);
    }
  }
}