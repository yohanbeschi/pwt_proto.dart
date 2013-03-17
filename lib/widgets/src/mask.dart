part of pwt_widgets;

class Mask extends ExtElement {
  
  StreamSubscription<Event> _resizeListener;
  
  bool _disableScroll;
  
  Mask() : super(new DivElement()) {
    _disableScroll = false;
    buildMask();
  }
 
  Element buildMask() {
    var css = this.style;
    css.margin = '0px';
    css.padding = '0px';
    css.position = 'absolute';
    css.width = '100%';
    css.top = '0';
    css.left = '0';
    css.overflow = 'auto';
    css.zIndex = '10000';
    css.backgroundColor = '#000';
    css.display = 'none';
    css.opacity = '0.7';
  }
  
    set backgroundColor(String backgroundColor) 
      => this.style.backgroundColor = backgroundColor;
    
    set zIndex(int zIndex) 
      => this.style.zIndex = zIndex.toString();
    
    set opacity(num opacity) 
      => this.style.opacity = opacity.toString();
  
    set disableScroll(bool disableScroll) 
      => this._disableScroll = disableScroll;
    
    void onClick(void elementOnClick(Event event)) {
      this.element.onClick.listen(elementOnClick);
    }
    
  void add() {
    document.body.append(this.element);
    
    if (_disableScroll) {
      $('body').style.overflow = 'hidden';
    }
    
    _resizeListener = window.onResize.listen(_resizeMask);
    _resizeMask(null);
    
    this.show();
  }
  
  void _resizeMask(Event event) {
    // hide the mask so our measurement doesn't include the mask
    this.hide();
    
    int height = max($(window).height, $(document).height);
    int width = max($(window).width, $(document).width);
    
    this.style.height = '${height}px';
    this.style.width = '${width}px';
    
    this.show();
  }
  void remove() {
    this.element.remove();
    _resizeListener.cancel();
    
    if (_disableScroll) {
      document.body.style.overflow = 'auto';
    }
  }
}

