part of pwt_widgets;

class LinedTextarea extends ExtElement {
  
  ExtElement _textarea;
  ExtElement linesDiv;
  int lineNo;
  
  LinedTextarea() : super(new DivElement()) {
    this.init();
  }
  
  void init() {
    lineNo = 1;
    
    linesDiv = new ExtElement.tag('div')
      ..classes.add('lines')
      ..style.width = '3%';
    
    _textarea = new ExtElement.tag('textarea')
      ..style.width = '97%';
      
    this.element
      ..classes.add('linedTextarea')
      ..style.height = '100%'
      ..style.overflow = 'hidden'
      ..append(linesDiv.element)
      ..append(textarea.element);
        
    /* React to the scroll event */
    _textarea.onScroll.listen(onScroll);
    
    window.onResize.listen((e) => _textarea.dispatchEvent(new Event('scroll')));
  }
  
  void fillOutLines(int h) {
    while (linesDiv.offsetHeight <= h) {
      linesDiv.appendHtml("<div>${lineNo}</div>");
      lineNo++;
    }
  }
  
  void onScroll(Event e) {
    var scrollTop = this.element.scrollTop;
    var clientHeight = this.element.clientHeight;

    linesDiv.style.marginTop = '${-scrollTop}px';

    fillOutLines(scrollTop + clientHeight);
  }
  
  ExtElement get lines => this.linesDiv;
  ExtElement get textarea => this._textarea;
}