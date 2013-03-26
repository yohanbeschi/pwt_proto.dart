part of pwt_layouts;

class BorderLayout {
  
  int borderSize;
  int outsideBorderSize;
  bool keepHandlesInside;
  
  ExtElement northWest;
  ExtElement north;
  ExtElement northEast;
  ExtElement east;
  ExtElement southEast;
  ExtElement south;
  ExtElement southWest;
  ExtElement west;
  ExtElement middle;
  
  bool westFromTop;
  bool westToBottom;
  bool eastFromTop;
  bool eastToBottom;
  
  // North-West/North
  bool handleNWN;
  // North/North-East
  bool handleNNE;
  // South-West/South
  bool handleSWS;
  // South/South-East
  bool handleSSE;
  // North-West/West
  bool handleNWW;
  // West/South-West
  bool handleWSW;
  // North-East/East
  bool handleNEE;
  // East/South-East
  bool handleESE;
  // North/Middle
  bool handleNM;
  // West/Middle
  bool handleWM;
  // South/Middle
  bool handleSM;
  // East/Middle
  bool handleEM;
  
  // North-West/North-East
  bool extendNWNE;
  // South-West/South-East
  bool extendSWSE;
  // North-West/South-West
  bool extendNWSW;
  // North-East/South-East
  bool extendNESE;
  
  // North-West/North
  bool extendNWN;
  // North/North-East
  bool extendNNE;
  // South-West/South
  bool extendSWS;
  // South/South-East
  bool extendSSE;
  // North-West/West
  bool extendNWW;
  // West/South-West
  bool extendWSW;
  // North-East/East
  bool extendNEE;
  // East/South-East 
  bool extendESE;
  
  ExtElement _handleNWN;
  ExtElement _handleNNE;
  ExtElement _handleSWS;
  ExtElement _handleSSE;
  ExtElement _handleNWW;
  ExtElement _handleWSW;
  ExtElement _handleNEE;
  ExtElement _handleESE;
  ExtElement _handleNM;
  ExtElement _handleWM;
  ExtElement _handleSM;
  ExtElement _handleEM;
  ExtElement _extendNWN;
  ExtElement _extendNNE;
  ExtElement _extendSWS;
  ExtElement _extendSSE;
  ExtElement _extendNWW;
  ExtElement _extendWSW;
  ExtElement _extendNEE;
  ExtElement _extendESE;
  
  BorderLayout({int this.borderSize:5, int this.outsideBorderSize:5, bool this.keepHandlesInside:false}) : westFromTop = false,
                   westToBottom = false,
                   eastFromTop = false,
                   eastToBottom = false,
                   handleNWN = false,
                   handleNNE = false,
                   handleSWS = false,
                   handleSSE = false,
                   handleNWW = false,
                   handleWSW = false,
                   handleNEE = false,
                   handleESE = false,
                   handleNM = false,
                   handleWM = false,
                   handleSM = false,
                   handleEM = false,
                   extendNWNE = false,
                   extendSWSE = false,
                   extendNWSW = false,
                   extendNESE = false,
                   extendNWN = false,
                   extendNNE = false,
                   extendSWS = false,
                   extendSSE = false,
                   extendNWW = false,
                   extendWSW = false,
                   extendNEE = false,
                   extendESE = false;
  
  void enableHandles() {
    handleNWN = true;
    handleNNE = true;
    handleSWS = true;
    handleSSE = true;
    handleNWW = true;
    handleWSW = true;
    handleNEE = true;
    handleESE = true;
    handleNM = true;
    handleWM = true;
    handleSM = true;
    handleEM = true;
  }
  
  void enableExtendedHandles() {
    extendNWNE = true;
    extendSWSE = true;
    extendNWSW = true;
    extendNESE = true;
  }
  
  void addTo(var parent, [String where = 'beforeEnd']) {
    final ExtElement containerParent = getExtElement(parent);
    final ExtElement extParent = new ExtElement(new DivElement());
    extParent.addClasses('pwt-border-layout');
    extParent.style.top = '${outsideBorderSize}px';
    extParent.style.left = '${outsideBorderSize}px';
    extParent.style.bottom = '${outsideBorderSize}px';
    extParent.style.right = '${outsideBorderSize}px';
    
    containerParent.insertAdjacentElement(where, extParent.element);
    
    addPanels(extParent);
    drawLayout();
    addHandles(extParent);
  }

  void addPanels(ExtElement extParent) {
    if (northWest != null) {
      extParent.append(northWest.element);
    }
    if (northEast != null) {
      extParent.append(northEast.element);
    }
    if (southWest != null) {
      extParent.append(southWest.element);
    }
    if (southEast!= null) {
      extParent.append(southEast.element);
    }
    if (north != null) {
      extParent.append(north.element);
    }
    if (south != null) {
      extParent.append(south.element);
    }
    if (west != null) {
      extParent.append(west.element);
    }
    if (east!= null) {
      extParent.append(east.element);
    }
    if (middle!= null) {
      extParent.append(middle.element);
    }
  }
  
  void drawLayout() {
    //---- Corners
    if (northWest != null) {
      northWest.style.position = 'absolute';
      northWest.style.left = '0'; //'${outsideBorderSize}px';
      northWest.style.top = '0'; //'${outsideBorderSize}px';
    }
    
    if (northEast != null) {
      northEast.style.position = 'absolute';
      northEast.style.right = '0'; //'${outsideBorderSize}px';
      northEast.style.top = '0'; //'${outsideBorderSize}px';
    }
    
    if (southWest != null) {
      southWest.style.position = 'absolute';
      southWest.style.left = '0'; //'${outsideBorderSize}px';
      southWest.style.bottom = '0'; //'${outsideBorderSize}px';
    }
    
    if (southEast!= null) {
      southEast.style.position = 'absolute';
      southEast.style.right = '0'; //'${outsideBorderSize}px';
      southEast.style.bottom = '0'; //'${outsideBorderSize}px';
    }
    
    //---- North, South, West, East
    // North
    if (north != null) {
      north.style.position = 'absolute';
      north.style.top = '0'; //'${outsideBorderSize}px';
      
      // Left 
      if (westFromTop && west != null) {
        north.style.left = '${west.val('width') + borderSize}px';
      } else if (northWest != null) {
        north.style.left = '${northWest.val('width') + borderSize}px';
      } else {
        north.style.left = '0'; //'${outsideBorderSize}px';
      }
    
      // Right
      if (eastFromTop && east != null) {
        north.style.right = '${borderSize + east.val('width')}px';
      } else if (northEast != null) {
        north.style.right = '${borderSize + northEast.val('width')}px';
      } else {
        north.style.right = '0'; //'${outsideBorderSize}px';
      }
    }
    
    // South
    if (south != null) {
      south.style.position = 'absolute';
      south.style.bottom = '0'; //'${outsideBorderSize}px';
      
      // Left 
      if (westToBottom && west != null) {
        south.style.left = '${west.val('width') + borderSize}px';
      } else if (southWest != null) {
        south.style.left = '${southWest.val('width') + borderSize}px';
      } else {
        south.style.left = '0'; //'${outsideBorderSize}px';
      }
    
      // Right
      if (eastToBottom && east != null) {
        south.style.right = '${borderSize + east.val('width')}px';
      } else if (southEast != null) {
        south.style.right = '${borderSize + southEast.val('width')}px';
      } else {
        south.style.right = '0'; //'${outsideBorderSize}px';
      }
    }
    
    // West
    if (west != null) {
      west.style.position = 'absolute';
      west.style.left = '0'; //'${outsideBorderSize}px';
      
      // Top
      if (westFromTop || north == null) {
        west.style.top = '0'; //'${outsideBorderSize}px';
      } else {
        west.style.top = '${north.val('height') + borderSize}px';
      }
      
      // Bottom
      if (westToBottom || south == null) {
        west.style.bottom = '0'; //'${outsideBorderSize}px';
      } else {
        west.style.bottom = '${borderSize + south.val('height')}px';
      }
    }
    
    // East
    if (east!= null) {
      east.style.position = 'absolute';
      east.style.right = '0'; //'${outsideBorderSize}px';
      
      // Top
      if (eastFromTop || north == null) {
        east.style.top = '0'; //'${outsideBorderSize}px';
      } else {
        east.style.top = '${north.val('height') + borderSize}px';
      }
      
      // Bottom
      if (eastToBottom || south == null) {
        east.style.bottom = '0'; //'${outsideBorderSize}px';
      } else {
        east.style.bottom = '${borderSize + south.val('height')}px';
      }
    }
    
    //----
    if (middle!= null) {
      middle.style.position = 'absolute';
      
      // Top
      if (north != null) {
        middle.style.top = '${north.val('height') + borderSize}px';
      } else {
        middle.style.top = '0'; //'${outsideBorderSize}px';
      }
      
      // Left
      if (west != null) {
        middle.style.left = '${west.val('width') + borderSize}px';
      } else {
        middle.style.left = '0'; //'${outsideBorderSize}px';
      }
      
      // Bottom
      if (south != null) {
        middle.style.bottom = '${south.val('height') + borderSize}px';
      } else {
        middle.style.bottom = '0'; //'${outsideBorderSize}px';
      }
      
      // Right
      if (east != null) {
        middle.style.right = '${east.val('width') + borderSize}px';
      } else {
        middle.style.right = '0'; //'${outsideBorderSize}px';
      }
    }
  }

  void addHandles(ExtElement extParent) {
    // Vertical Top
    if (extendNWNE && north != null) {
      final ExtElement e = new ExtElement(new DivElement());
      e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
      e.style.height = '${borderSize}px';
      e.style.top = '${north.val('height')}px';
      e.style.left = '0';
      e.style.right = '0';
      extParent.append(e.element);
      
      Function changeHeight = getChangeHeigthNorth();
      Function changeTop = getChangeTopMiddle();
      
      verticalDragging(extParent, e, updateHandlesExtendNWNE, changeHeight, changeTop, middle, 1);
    } else {
      if (extendNWN && north != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.top = '${north.val('height')}px';
        e.style.left = '0';
        
        setExtendNWNRight(e);
        extParent.append(e.element);

        Function changeHeight = getChangeHeigthNorthWestNorth();
        Function changeTop = getChangeTopWestMiddle();
        
        verticalDragging(extParent, e, updateHandlesExtendNWN, changeHeight, changeTop, middle, 1);
        _extendNWN = e;
      } else if (extendNNE && north != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.top = '${north.val('height')}px';
        e.style.right = '0';
        
        setExtendNNELeft(e);
        
        extParent.append(e.element);

        Function changeHeight = getChangeHeightNorthNorthEast();
        Function changeTop = getChangeTopMiddleEast();
        
        verticalDragging(extParent, e, updateHandlesExtendNNE, changeHeight, changeTop, middle, 1);
        _extendNNE = e;
      } 
      
      if (!extendNWN && handleNWW && northWest != null && west != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.width = '${northWest.val('width')}px';
        e.style.top = '${northWest.val('height')}px';
        e.style.left = '0';
        extParent.append(e.element);

        verticalDragging(extParent, e, (){}, changeHeightNorthWest, changeTopWest, west, 1);
        _handleNWW = e;
      }
      
      if (!extendNWN && !extendNNE  && handleNM && north != null && middle != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.width = '${north.val('width')}px';
        e.style.top = '${north.val('height')}px';
        
        setHandleNMLeft(e);
        extParent.append(e.element);

        verticalDragging(extParent, e, (){}, changeHeightNorth, changeTopMiddle, middle, 1);
        _handleNM = e;
      }
      
      if (!extendNNE  && handleNEE && north != null && northEast != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.width = '${northEast.val('width')}px';
        e.style.top = '${northEast.val('height')}px';
        e.style.right = '0';
        extParent.append(e.element);

        verticalDragging(extParent, e, (){}, changeHeightNorthEast, changeTopEast, east, 1);
        _handleNEE = e;
      }
    }
    
    // Vertical Bottom
    if (extendSWSE && south != null) {
      final ExtElement e = new ExtElement(new DivElement());
      e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
      e.style.height = '${borderSize}px';
      e.style.bottom = '${south.val('height')}px';
      e.style.left = '0';
      e.style.right = '0';
      extParent.append(e.element);
      
      Function changeHeight = getChangeHeightSouth();
      Function changeBottom = getChangeBottomMiddle();
      
      verticalDragging(extParent, e, updateHandlesExtendSWSE, changeHeight, changeBottom, middle, -1);
    } else {
      if (extendSWS && south != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.bottom = '${south.val('height')}px';
        e.style.left = '0';
        
        setExtendSWSRight(e);
        
        extParent.append(e.element);
        
        Function changeHeight = getChangeHeigthSouthWestSouth();
        Function changeBottom = getChangeBottomWestMiddle();
        
        verticalDragging(extParent, e, updateHandlesExtendSWS, changeHeight, changeBottom, middle, -1);
        _extendSWS = e;
      } else if (extendSSE && south != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.bottom = '${south.val('height')}px';
        e.style.right = '0';
        
        setExtendSSELeft(e);
        
        extParent.append(e.element);
        
        Function changeHeight = getChangeHeigthSouthSouthEast();
        Function changeBottom = getChangeBottomMiddleEast();
        
        verticalDragging(extParent, e, updateHandlesExtendSSE, changeHeight, changeBottom, middle, -1);
        _extendSSE = e;
      }
      
      if (!extendSWS && handleWSW && southWest != null && west != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.width = '${southWest.val('width')}px';
        e.style.bottom = '${southWest.val('height')}px';
        e.style.left = '0';
        extParent.append(e.element);

        verticalDragging(extParent, e, (){}, changeHeightSouthWest, changeBottomWest, west, -1);
        _handleWSW = e;
      }

      if (!extendSWS && !extendSSE && handleSM && south != null && middle != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.width = '${south.val('width')}px';
        e.style.bottom = '${south.val('height')}px';
        
        setHandleSMLeft(e);
        extParent.append(e.element);

        verticalDragging(extParent, e, (){}, changeHeightSouth, changeBottomMiddle, middle, -1);
        _handleSM = e;
      }
      
      if (!extendSSE && handleESE && east != null && southEast != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-vetical-cursor');
        e.style.height = '${borderSize}px';
        e.style.width = '${southEast.val('width')}px';
        e.style.bottom = '${southEast.val('height')}px';
        e.style.right = '0';
        extParent.append(e.element);

        verticalDragging(extParent, e, (){}, changeHeightSouthEast, changeBottomEast, east, -1);
        _handleESE = e;
      }
    }
    
    // Horizontal Left
    if (extendNWSW && west != null) {
      final ExtElement e = new ExtElement(new DivElement());
      e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
      e.style.width = '${borderSize}px';
      e.style.top = '0';
      e.style.bottom = '0';
      e.style.left = '${west.val('width')}px';
      extParent.append(e.element);
      
      Function changeWidth = getChangeWidthLeft();
      Function changeLeft = getChangeLeftMiddle();
      
      horizontalDragging(extParent, e, updateHandlesExtendNWSW, changeWidth, changeLeft, middle, 1);
    } else {
      if (extendNWW && west != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.width = '${borderSize}px';
        e.style.top = '0';
        e.style.left = '${west.val('width')}px';
        
        setExtendNWWBottom(e);
        
        extParent.append(e.element);
        
        Function changeWidth = getChangeWidthNorthWestWest();
        Function changeLeft = getChangeLeftNorthMiddle();
        
        horizontalDragging(extParent, e, updateHandlesExtendNWW, changeWidth, changeLeft, middle, 1);
        _extendNWW = e;
      } else if (extendWSW && west != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.width = '${borderSize}px';
        e.style.bottom = '0';
        e.style.left = '${west.val('width')}px';
        
        setExtendWSWTop(e);
        
        extParent.append(e.element);
        
        Function changeWidth = getChangeWidthWestSouthWest();
        Function changeLeft = getChangeLeftMiddleSouth();
        
        horizontalDragging(extParent, e, updateHandlesExtendWSW, changeWidth, changeLeft, middle, 1);
        _extendWSW = e;
      }
      
      if (!extendNWW && handleNWN && northWest != null && north != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.height = '${north.val('height')}px';
        e.style.width = '${borderSize}px';
        e.style.top = '0';
        e.style.left = '${northWest.val('width')}px';
        extParent.append(e.element);
        
        horizontalDragging(extParent, e, (){}, changeWidthNorthWest, changeLeftNorth, north, 1);
        _handleNWN = e;
      }
      
      if (!extendNWW && !extendWSW && handleWM && west != null && middle != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.height = '${west.val('height')}px';
        e.style.width = '${borderSize}px';
        e.style.left = '${west.val('width')}px';
        
        setHandleWMTop(e);
        extParent.append(e.element);

        horizontalDragging(extParent, e, (){}, changeWidthWest, changeLeftMiddle, middle, 1);
        _handleWM = e;
      }
      
      if (!extendWSW && handleSWS && southWest != null && south != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.height = '${south.val('height')}px';
        e.style.width = '${borderSize}px';
        e.style.bottom = '0';
        e.style.left = '${southWest.val('width')}px';
        extParent.append(e.element);
        
        horizontalDragging(extParent, e, (){}, changeWidthSouthWest, changeLeftSouth, south, 1);
        _handleSWS = e;
      }
    }
    
    // Horizontal Right
    if (extendNESE && east != null) {
      final ExtElement e = new ExtElement(new DivElement());
      e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
      e.style.width = '${borderSize}px';
      e.style.top = '0';
      e.style.bottom = '0';
      e.style.right = '${east.val('width')}px';
      extParent.append(e.element);
      
      Function changeWidth = getChangeWidthRight();
      Function changeRight = getChangeRightMiddle();
      
      horizontalDragging(extParent, e, updateHandlesExtendNESE, changeWidth, changeRight, middle, -1);
    } else {
      if (extendNEE && east != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.width = '${borderSize}px';
        e.style.top = '0';
        e.style.right = '${east.val('width')}px';
        
        setExtendNEEBottom(e);
        
        extParent.append(e.element);
        
        Function changeWidth = getChangeWidthNorthEastEast();
        Function changeRight = getChangeRightNorthMiddle();
        
        horizontalDragging(extParent, e, updateHandlesExtendNEE, changeWidth, changeRight, middle, -1);
        _extendNEE = e;
      } else if (extendESE && east != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.width = '${borderSize}px';
        e.style.bottom = '0';
        e.style.right = '${east.val('width')}px';
        
        setExtendESETop(e);
        
        extParent.append(e.element);
        
        Function changeWidth = getChangeWidthEastSouthEast();
        Function changeRight = getChangeRightMiddleSouth();
        
        horizontalDragging(extParent, e, updateHandlesExtendESE, changeWidth, changeRight, middle, -1);
        _extendESE = e;
      }

      if (!extendNEE && handleNNE && north != null && northEast != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.height = '${north.val('height')}px';
        e.style.width = '${borderSize}px';
        e.style.top = '0';
        e.style.right = '${northEast.val('width')}px';
        extParent.append(e.element);

        horizontalDragging(extParent, e, (){}, changeWidthNorthEast, changeRightNorth, north, -1);
        _handleNNE = e;
      }
      
      if (!extendNEE && !extendESE && handleEM && east != null && middle != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.height = '${east.val('height')}px';
        e.style.width = '${borderSize}px';
        e.style.right = '${east.val('width')}px';
        
        setHandleEMTop(e);
        extParent.append(e.element);

        horizontalDragging(extParent, e, (){}, changeWidthEast, changeRightMiddle, middle, -1);
        _handleEM = e;
      }
      
      if (!extendESE && handleSSE && south != null && southEast != null) {
        final ExtElement e = new ExtElement(new DivElement());
        e.addClasses('pwt-border-layout-handle pwt-horizontal-cursor');
        e.style.height = '${south.val('height')}px';
        e.style.width = '${borderSize}px';
        e.style.bottom = '0';
        e.style.right = '${southEast.val('width')}px';
        extParent.append(e.element);

        horizontalDragging(extParent, e, (){}, changeWidthSouthEast, changeRightSouth, south, -1);
        _handleSSE = e;
      }
    }
  }

  void verticalDragging(ExtElement container, ExtElement e, Function resizeHandles, Function f1, Function f2, ExtElement maxHeightElement, int sign) {
    e.draggable()
    ..container = container
    ..axis = Axis.Y_AXIS
    ..onDrag((DragEvent e) {
      if (sign == -1) {
        e.drag.topLimit = maxHeightElement.height;
      } else {
        e.drag.bottomLimit = maxHeightElement.height;
      }
      document.body.style.cursor = 'n-resize';
    })
    ..onMove((DragEvent event) {
      final int delta = event.drag.deltaPosition.top;
      f1(delta);
      f2(delta);
    })
    ..onDrop((_) {
      document.body.style.cursor = '';
      resizeHandles();
    });
  }
  
  void horizontalDragging(ExtElement container, ExtElement e, Function resizeHandles, Function f1, Function f2, ExtElement maxWidthElement, int sign) {
    e.draggable()
    ..container = container
    ..axis = Axis.X_AXIS
    ..onDrag((DragEvent e) {
      if (sign == -1) {
        e.drag.leftLimit = maxWidthElement.width;
      } else {
        e.drag.rightLimit = maxWidthElement.width;
      }
      
      document.body.style.cursor = 'e-resize';
    })
    ..onMove((DragEvent event) {
      final int delta = event.drag.deltaPosition.left;
      f1(delta);
      f2(delta);
    })
    ..onDrop((_) {
      document.body.style.cursor = '';
      resizeHandles();
    });
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  // Vertical Function generator
  //--------------------------------------------------------------------------------------------------------------------
  Function getChangeHeigthNorth() {
    return getChangeSize(northWest, north, northEast, changeHeightNorthWest, changeHeightNorth, changeHeightNorthEast);
  }

  Function getChangeTopMiddle() {
    return getChangeSize(west, middle, east, changeTopWest, changeTopMiddle, changeTopEast);
  }
  
  Function getChangeBottomMiddle() {
    return getChangeSize(west, middle, east, changeBottomWest, changeBottomMiddle, changeBottomEast);
  }
  
  Function getChangeHeightSouth() {
    return getChangeSize(southWest, south, southEast, changeHeightSouthWest, changeHeightSouth, changeHeightSouthEast);
  }
  
  Function getChangeHeigthNorthWestNorth() {
    return getChangeSize2(northWest, north, changeHeightNorthWest, changeHeightNorth);
  }
  
  Function getChangeTopWestMiddle() {
    return getChangeSize2(west, middle, changeTopWest, changeTopMiddle);
  }

  Function getChangeHeightNorthNorthEast() {
    return getChangeSize2(north, northEast, changeHeightNorth, changeHeightNorthEast);
  }
  
  Function getChangeTopMiddleEast() {
    return getChangeSize2(middle, east, changeTopMiddle, changeTopEast);
  }
  
  Function getChangeHeigthSouthWestSouth() {
    return getChangeSize2(southWest, south, changeHeightSouthWest, changeHeightSouth);
  }
  
  Function getChangeBottomWestMiddle() {
    return getChangeSize2(west, middle, changeBottomWest, changeBottomMiddle);
  }
  
  Function getChangeHeigthSouthSouthEast() {
    return getChangeSize2(south, southEast, changeHeightSouth, changeHeightSouthEast);
  }
  
  Function getChangeBottomMiddleEast() {
    return getChangeSize2(middle, east, changeBottomMiddle, changeBottomEast);
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  // Horizontal Function generator
  //--------------------------------------------------------------------------------------------------------------------
  Function getChangeWidthLeft() {
    return getChangeSize(northWest, west, southWest, changeWidthNorthWest, changeWidthWest, changeWidthSouthWest);
  }
  
  Function getChangeLeftMiddle() {
    return getChangeSize(north, middle, south, changeLeftNorth, changeLeftMiddle, changeLeftSouth);
  }

  Function getChangeWidthRight() {
    return getChangeSize(northEast, east, southEast, changeWidthNorthEast, changeWidthEast, changeWidthSouthEast);
  }
  
  Function getChangeRightMiddle() {
    return getChangeSize(north, middle, south, changeRightNorth, changeRightMiddle, changeRightSouth);
  }
  
  Function getChangeWidthNorthWestWest() {
    return getChangeSize2(northWest, west, changeWidthNorthWest, changeWidthWest);
  }

  Function getChangeLeftNorthMiddle() {
    return getChangeSize2(north, middle, changeLeftNorth, changeLeftMiddle);
  }
  
  Function getChangeWidthWestSouthWest() {
    return getChangeSize2(west, southWest, changeWidthWest, changeWidthSouthWest);
  }

  Function getChangeLeftMiddleSouth() {
    return getChangeSize2(middle, south, changeLeftMiddle, changeLeftSouth);
  }
  
  Function getChangeWidthNorthEastEast() {
    return getChangeSize2(northEast, east, changeWidthNorthEast, changeWidthEast);
  }

  Function getChangeRightNorthMiddle() {
    return getChangeSize2(north, middle, changeRightNorth, changeRightMiddle);
  }
  
  Function getChangeWidthEastSouthEast() {
    return getChangeSize2(east, southEast, changeWidthEast, changeWidthSouthEast);
  }

  Function getChangeRightMiddleSouth() {
    return getChangeSize2(middle, south, changeRightMiddle, changeRightSouth);
  }

  //Function 
  Function getChangeSize(ExtElement e1, ExtElement e2, ExtElement e3, 
                     Function f1, Function f2, Function f3) {
    if (e2 == null) return (int delta){};

    if (e1 != null && e2 != null) {
      return (int delta) {
          f1(delta);
          f2(delta);
          f3(delta);
      };
    } else if (e1 != null) {
      return (int delta) {
        f1(delta);
        f2(delta);
      };
    } else if (e3 != null) {
      return (int delta) {
        f2(delta);
        f3(delta);
      };
    } else {
      return (int delta) {
        f2(delta);
      };
    }
  }
  
  Function getChangeSize2(ExtElement e1, ExtElement e2, 
                         Function f1, Function f2) {
    if (e1 != null && e2 != null) {
      return (int delta) {
        f1(delta);
        f2(delta);
      };
    } else if (e1 != null) {
      return (int delta) {
        f1(delta);
      };
    } else {
      return (int delta) {
        f2(delta);
      };
    }
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  // Vertical
  //--------------------------------------------------------------------------------------------------------------------
  // Top
  void changeHeightNorthWest(int delta) {
    changeHeight(northWest, delta);
  }
  
  void changeHeightNorth(int delta) {
    changeHeight(north, delta);
  }
  
  void changeHeightNorthEast(int delta) {
    changeHeight(northEast, delta);
  }
  
  // Middle/Top
  void changeTopWest(int delta) {
    changeTop(west, delta);
  }
  
  void changeTopMiddle(int delta) {
    changeTop(middle, delta);
  }
  
  void changeTopEast(int delta) {
    changeTop(east, delta);
  }
  
  // Middle/Bottom
  void changeBottomWest(int delta) {
    changeBottom(west, -delta);
  }
  
  void changeBottomMiddle(int delta) {
    changeBottom(middle, -delta);
  }
  
  void changeBottomEast(int delta) {
    changeBottom(east, -delta);
  }
  
  // Bottom
  void changeHeightSouthWest(int delta) {
    changeHeight(southWest, -delta);
  }
  
  void changeHeightSouth(int delta) {
    changeHeight(south, -delta);
  }
  
  void changeHeightSouthEast(int delta) {
    changeHeight(southEast, -delta);
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  // Horizontal
  //--------------------------------------------------------------------------------------------------------------------
  // Left
  void changeWidthNorthWest(int delta) {
    changeWidth(northWest, delta);
  }
  
  void changeWidthWest(int delta) {
    changeWidth(west, delta);
    //change(west,delta, 'width', 'left', changeWidth, changeLeft);
  }
  
  void changeWidthSouthWest(int delta) {
    changeWidth(southWest, delta);
  }

  // Middle/Left
  void changeLeftNorth(int delta) {
    changeLeft(north, delta);
  }
  
  void changeLeftMiddle(int delta) {
    changeLeft(middle, delta);
  }
  
  void changeLeftSouth(int delta) {
    changeLeft(south, delta);
  }
  
  // Middle/Right
  void changeRightNorth(int delta) {
    changeRight(north, -delta);
  }
  
  void changeRightMiddle(int delta) {
    changeRight(middle, -delta);
  }
  
  void changeRightSouth(int delta) {
    changeRight(south, -delta);
  }

  // Right
  void changeWidthNorthEast(int delta) {
    changeWidth(northEast, -delta);
  }
  
  void changeWidthEast(int delta) {
    changeWidth(east, -delta);
  }
  
  void changeWidthSouthEast(int delta) {
    changeWidth(southEast, -delta);
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  // Utils
  //--------------------------------------------------------------------------------------------------------------------
  void change(ExtElement element, int delta, 
              String sizeProperty, String offsetProperty, 
              Function changeSize, Function changeOffset) {
    if (delta != 0) {
      final int size = element.val(sizeProperty);
      final int offset = element.val(offsetProperty);

      if (offset == 5) {
        if ((size + delta) <= 0) {
          element.style.setProperty(offsetProperty, '0');
        }
        
        changeSize(element, delta);
      } else {
        int newOffset = offset + delta;
        if (newOffset <= 0) {
          element.style.setProperty(offsetProperty, '0');
        } else if (newOffset < 5) {
          changeOffset(element, delta);
        } else {
          element.style.setProperty(offsetProperty, '5px');
          changeSize(element, newOffset - 5);
        }
      }
    }
  }
  
  void changeHeight(ExtElement element, int delta) {
    int newPosition = element.height + delta;
    newPosition = newPosition < 0 ? 0 : newPosition;
    element.style.height = '${newPosition}px';
  }
  
  void changeWidth(ExtElement element, int delta) {
    int newPosition = element.width + delta;
    newPosition = newPosition < 0 ? 0 : newPosition;
    element.style.width = '${newPosition}px';
  }
  
  void changeTop(ExtElement element, int delta) {
    final int newPosition = element.val('top') + delta;
    element.style.top = '${newPosition}px';
  }
  
  void changeBottom(ExtElement element, int delta) {
    final int newPosition = element.val('bottom') + delta;
    element.style.bottom = '${newPosition}px';
  }
  
  void changeLeft(ExtElement element, int delta) {
    final int newPosition = element.val('left') + delta;
    element.style.left = '${newPosition}px';
  }
  
  void changeRight(ExtElement element, int delta) {
    final int newPosition = element.val('right') + delta;
    element.style.right = '${newPosition}px';
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  // Resize Handlers
  //--------------------------------------------------------------------------------------------------------------------
  void setExtendNEEBottom(ExtElement e) {
    int bottom;
    if (southEast != null) {
      bottom = southEast.val('height') + borderSize;
      bottom = south.val('height') + borderSize;
    } else {
      bottom = 0;
    }
    
    e.style.bottom = '${bottom}px';
  }

  void setExtendSSELeft(ExtElement e) {
    int left;
    if (southWest != null) {
      left = southWest.val('width') + borderSize;
    } else if (west != null) {
      left = west.val('width') + borderSize;
    } else {
      left = 0;
    }
    
    e.style.left = '${left}px';
  }

  void setExtendSWSRight(ExtElement e) {
    int right;
    if (southEast != null) {
      right = southEast.val('width') + borderSize;
    } else if (east != null) {
      right = east.val('width') + borderSize;
    } else {
      right = 0;
    }
    
    e.style.right = '${right}px';
  }

  void setExtendNNELeft(ExtElement e) {
    int left;
    if (northWest != null) {
      left = northWest.val('width') + borderSize;
    } else if (west != null) {
      left = west.val('width') + borderSize;
    } else {
      left = 0;
    }
    
    e.style.left = '${left}px';
  }

  void setExtendNWNRight(ExtElement e) {
    int right;
    if (northEast != null) {
      right = northEast.val('width') + borderSize;
    } else if (east != null) {
      right = east.val('width') + borderSize;
    } else {
      right = 0;
    }
    
    e.style.right = '${right}px';
  }

  void setExtendWSWTop(ExtElement e) {
    setHandleWMTop(e);
  }

  void setExtendESETop(ExtElement e) {
    setHandleEMTop(e);
  }
  
  void setExtendNWWBottom(ExtElement e) {
    int bottom;
    if (southWest != null) {
      bottom = southWest.val('height') + borderSize;
    } if (south != null) {
      bottom = south.val('height') + borderSize;
    } else {
      bottom = 0;
    }
    
    e.style.bottom = '${bottom}px';
  }
  
  void setHandleNMLeft(ExtElement e) {
    int left;
    if (northWest != null) {
      left = northWest.val('width') + borderSize;
    } else if (west != null) {
      left = west.val('width') + borderSize;
    } else {
      left = 0;
    }
    
    e.style.left = '${left}px';
  }
  
  void setHandleWMTop(ExtElement e) {
    int top;
    if (northWest != null) {
      top = northWest.val('height') + borderSize;
    } else if (north != null) {
      top = north.val('height') + borderSize;
    } else {
      top = 0;
    }
    
    e.style.top = '${top}px';
  }
  
  void setHandleSMLeft(ExtElement e) {
    int left;
    if (southWest != null) {
      left = southWest.val('width') + borderSize;
    } else if (west != null) {
      left = west.val('width') + borderSize;
    } else {
      left = 0;
    }
    
    e.style.left = '${left}px';
  }
  
  void setHandleEMTop(ExtElement e) {
    int top;
    if (northEast != null) {
      top = northEast.val('height') + borderSize;
    } else if (north != null) {
      top = north.val('height') + borderSize;
    } else {
      top = 0;
    }
    
    e.style.top = '${top}px';
  }
  
  void updateHandlesExtendNWNE() {
    if (extendWSW) {
      setExtendWSWTop(_extendWSW);
    } else if (handleWM) {
      setHandleWMTop(_handleWM);
      _handleWM.style.height = '${middle.val('height')}px';
    }
    
    if (extendESE) {
      setExtendESETop(_extendESE);
    } else if (handleEM) {
      setHandleEMTop(_handleEM);
      _handleEM.style.height = '${middle.val('height')}px';
    }
    
    if (handleNWN) {
      _handleNWN.style.height = '${north.val('height')}px';
    }
    
    if (handleNNE) {
      _handleNNE.style.height = '${north.val('height')}px';
    }
  }
  
  void updateHandlesExtendNWN() {
    if (extendWSW) {
      setExtendWSWTop(_extendWSW);
    } else if (handleWM) {
      setHandleWMTop(_handleWM);
      _handleWM.style.height = '${middle.val('height')}px';
    }
    
    if (handleNWN) {
      _handleNWN.style.height = '${north.val('height')}px';
    }
  }
  
  void updateHandlesExtendNNE() {
    if (extendESE) {
      setExtendESETop(_extendESE);
    } else if (handleEM) {
      setHandleEMTop(_handleEM);
      _handleEM.style.height = '${middle.val('height')}px';
    }
    
    if (handleNNE) {
      _handleNNE.style.height = '${north.val('height')}px';
    }
  }
  
  void updateHandlesExtendSWSE() {
    if (extendNWW) {
      setExtendNWWBottom(_extendNWW);
      _extendNWW.style.top = '';
    } else if (handleWM) {
      _handleWM.style.height = '${middle.val('height')}px';
    }
    
    if (extendNEE) {
      setExtendNEEBottom(_extendNEE);
      _extendNEE.style.top = '';
    } else if (handleEM) {
      _handleEM.style.height = '${middle.val('height')}px';
    }
    
    if (handleSWS) {
      _handleSWS.style.height = '${south.val('height')}px';
      _handleSWS.style.top = '';
    }
    
    if (handleSSE) {
      _handleSSE.style.height = '${south.val('height')}px';
      _handleSSE.style.top = '';
    }
  }
  
  void updateHandlesExtendSWS() {
    if (extendNWW) {
      setExtendNWWBottom(_extendNWW);
      _extendNWW.style.top = '';
    } else if (handleWM) {
      _handleWM.style.height = '${middle.val('height')}px';
    }
    
    if (handleSWS) {
      _handleSWS.style.height = '${south.val('height')}px';
      _handleSWS.style.top = '';
    }
  }
  
  void updateHandlesExtendSSE() {
    if (extendNEE) {
      setExtendNEEBottom(_extendNEE);
      _extendNEE.style.top = '';
    } else if (handleEM) {
      _handleEM.style.height = '${middle.val('height')}px';
    }
    
    if (handleSSE) {
      _handleSSE.style.height = '${south.val('height')}px';
      _handleSSE.style.top = '';
    }
  }
  
  void updateHandlesExtendNWSW() {
    if (extendNNE) {
      setExtendNNELeft(_extendNNE);
    } else if (handleNM) {
      setHandleNMLeft(_handleNM);
      _handleNM.style.width = '${middle.val('width')}px';
    }
    
    if (extendSSE) {
      setExtendSSELeft(_extendSSE);
    } else if (handleSM) {
      setHandleSMLeft(_handleSM);
      _handleSM.style.width = '${middle.val('width')}px';
    }
    
    if (handleNWW) {
      _handleNWW.style.width = '${west.val('width')}px';
    }
    
    if (handleWSW) {
      _handleWSW.style.width = '${west.val('width')}px';
    }
  }
  
  void updateHandlesExtendNWW() {
    if (extendNNE) {
      setExtendNNELeft(_extendNNE);
    } else if (handleNM) {
      setHandleNMLeft(_handleNM);
      _handleNM.style.width = '${middle.val('width')}px';
    }
    
    if (handleNWW) {
      _handleNWW.style.width = '${west.val('width')}px';
    }
  }
  
  void updateHandlesExtendWSW() {
    if (extendSSE) {
      setExtendSSELeft(_extendSSE);
    } else if (handleSM) {
      setHandleSMLeft(_handleSM);
      _handleSM.style.width = '${middle.val('width')}px';
    }
    
    if (handleWSW) {
      _handleWSW.style.width = '${west.val('width')}px';
    }
  }
  
  void updateHandlesExtendNESE() {
    if (extendNWN) {
      setExtendNWNRight(_extendNWN);
      _extendNWN.style.left = '';
    } else if (handleNM) {
      _handleNM.style.width = '${middle.val('width')}px';
    }
    
    if (extendSWS) {
      setExtendSWSRight(_extendSWS);
    } else if (handleSM) {
      _handleSM.style.width = '${middle.val('width')}px';
    }
    
    if (handleNEE) {
      _handleNEE.style.width = '${east.val('width')}px';
      _handleNEE.style.left = '';
    }
    
    if (handleESE) {
      _handleESE.style.width = '${east.val('width')}px';
      _handleESE.style.left = '';
    }
  }
  
  void updateHandlesExtendNEE() {
    if (extendNWN) {
      setExtendNWNRight(_extendNWN);
      _extendNWN.style.left = '';
    } else if (handleNM) {
      _handleNM.style.width = '${middle.val('width')}px';
    }
    
    if (handleNEE) {
      _handleNEE.style.width = '${east.val('width')}px';
      _handleNEE.style.left = '';
    }
  }
  
  void updateHandlesExtendESE() {
    if (extendSWS) {
      setExtendSWSRight(_extendSWS);
      _extendNWN.style.left = '';
    } else if (handleSM) {
      _handleSM.style.width = '${middle.val('width')}px';
    }
    
    if (handleESE) {
      _handleESE.style.width = '${east.val('width')}px';
      _handleESE.style.left = '';
    }
  }
}