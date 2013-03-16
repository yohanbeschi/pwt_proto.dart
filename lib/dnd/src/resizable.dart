part of pwt_dnd;

class Resizable {
  ExtElement box;
  
  bool _useShadow;
  String _shodowClass;
  bool _animate;
  
  Resizable(var element, {bool useShadow : false, bool animate : false}) {
    assertTrue(element is String || element is Element);
  
    box = getExtElement(element);

    _animate = animate;
    _useShadow = _animate ? true : useShadow;
    prepareForResizing();
  }
  
  void prepareForResizing() {
    box.style.position = 'relative';
    
    final DivElement east = new DivElement();
    east.style.position = 'absolute';
    east.style.fontSize= '0.1px';
    east.style.cursor = 'e-resize';
    east.style.width = '7px';
    east.style.right = '-5px';
    east.style.height = '100%';
    east.style.top = '0';
    
    if (!_useShadow) {
      new ExtElement(east).draggable()
        ..container = box.element
        ..enableOnlyUpperLimits()
        ..axis = Axis.X_AXIS
        ..onDrag((_) {document.body.style.cursor = 'e-resize';})
        ..onMove((var d)
            { box.style.width = '${box.width + d.drag.deltaPosition.left}px';}
        )
        ..onDrop((_) {
          east.style.left = '';
          east.style.top = '';
          document.body.style.cursor = '';
        });
    } else {
      new DraggableShadow(east, box, new PwtDragCoreOptions.map({'cursorAsOrigin':false,
        'axis':Axis.X_AXIS,
        'container':new ExtElement(box.element),
        'onlyUpperLimits':true,
        'onDrop': onShadowDrop}))..outsideBorder = false;
    }
    box.insertAdjacentElement('beforeEnd', east);
    
    final DivElement south = new DivElement();
    south.style.position = 'absolute';
    south.style.fontSize= '0.1px';
    south.style.cursor = 's-resize';
    south.style.width = '100%';
    south.style.left = '0';
    south.style.height = '7px';
    south.style.bottom = '-5px';
    if (!_useShadow) {
      new ExtElement(south).draggable()
        ..container = box.element
        ..enableOnlyUpperLimits()
        ..axis = Axis.Y_AXIS
        ..onDrag((_) {document.body.style.cursor = 's-resize';})
        ..onMove((var d) { 
          box.style.height = '${box.height + d.drag.deltaPosition.top}px';
        })
        ..onDrop((_) {
          south.style.left = '';
          south.style.top = '';
          document.body.style.cursor = '';
        });
    } else {
      new DraggableShadow(south, box, new PwtDragCoreOptions.map({'cursorAsOrigin':false,
        'axis':Axis.Y_AXIS,
        'container':new ExtElement(box.element),
        'onlyUpperLimits':true,
        'onDrop': onShadowDrop}))..outsideBorder = false;
 
    }
    box.insertAdjacentElement('beforeEnd', south);
    
    final DivElement southEast = new DivElement();
    southEast.style.position = 'absolute';
    southEast.style.fontSize= '0.1px';
    southEast.style.cursor = 'se-resize';
    southEast.style.width = '16px';
    southEast.style.height = '16px';
    southEast.style.right = '0px';
    southEast.style.bottom = '0px';
    southEast.style.background = 'url(../img/resize-xy.gif)';
    if (!_useShadow) {
      new ExtElement(southEast).draggable()
        ..container = box.element
        ..enableOnlyUpperLimits()
        ..onDrag((_) {document.body.style.cursor = 'se-resize';})
        ..onMove((var d) {
          box.style.height = '${box.height + d.drag.deltaPosition.top}px';
          box.style.width = '${box.width + d.drag.deltaPosition.left}px';
        })
        ..onDrop((_) {
          southEast.style.left = '';
          southEast.style.top = '';
          document.body.style.cursor = '';
        });
    } else {
      new DraggableShadow(southEast, box, new PwtDragCoreOptions.map({'cursorAsOrigin':false,
        'container':new ExtElement(box.element),
        'onlyUpperLimits':true,
        'onDrop': onShadowDrop}))..outsideBorder = false;
    }
    box.insertAdjacentElement('beforeEnd', southEast);
  }
  
  void  _startDragMouse(MouseEvent mouseEvent) {
    
  }
  
  void onShadowDrop(PwtDragEvent e) {
    final int height = e.object.shadow.height - box.val('padding-top') - box.val('padding-bottom');
    final int width = e.object.shadow.width - box.val('padding-left') - box.val('padding-right');
    
    if (_animate) {
      final num distance = pow(
          pow(e.object.model.height - height, 2)
          + pow(e.object.model.width - width, 2),
          0.5
      );
      final num duration = 0.3 + (distance / 1000);
      final Animation animation = new Animation(this.box.element, duration, 
          {'height': '${height}px',
        'width': '${width}px'});
      animation.start();
      
    } else {
      box.style.height = '${height}px';
      box.style.width = '${width}px';
    }
  }
}
