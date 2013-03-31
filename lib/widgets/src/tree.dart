part of pwt_widgets;

typedef dynamic Accessor(dynamic data);
typedef String ConditionalClasses(dynamic data, TreeNodeDataWrapper wrapper);
typedef bool ConditionalFeature(dynamic data, TreeNodeDataWrapper wrapper);
typedef OnTreeAction ConditionalFunction(dynamic data, TreeNodeDataWrapper wrapper);
typedef void OnTreeAction(MouseEvent mouseEvent, dynamic data, TreeNodeDataWrapper wrapper);

class TreeConfig {
  //---- Data
  Accessor _key;
  Accessor _value;
  Accessor _children;

  //---- CSS
  // Compatible with noFeature 
  ConditionalClasses conditionalUlClasses;
    set ulClasses(String classes) 
      => conditionalUlClasses = (a, b) => classes;
  
  ConditionalClasses conditionalLiClasses;
    set liClasses(String classes) 
      => conditionalLiClasses = (a, b) => classes;
    
  // Not compatible with noFeature

  //---- Features
  // Is this node opened by default
  ConditionalFeature conditionalOpenedAtFirst;
    set openedAtFirst(String openedAtFirst) 
      => conditionalOpenedAtFirst = (a, b) => openedAtFirst;
  
  ConditionalFeature conditionalUseIcons;
    set useIcons(bool useIcons) 
      => conditionalUseIcons = (a, b) => useIcons;
  
  // Is this node always opened
  ConditionalFeature conditionalAlwaysOpened;
  
  // Is this node expandable
  ConditionalFeature conditionalExpandable;

  // Function that will be added to element
  ConditionalFunction conditionalOnClick;
    set onClick(OnTreeAction e) => 
        conditionalOnClick = ((a, b) => e);
  
  ConditionalFeature conditionalSelectable;
    set selectable(bool selectable) 
      => conditionalSelectable = (a, b) => selectable;
    
  TreeConfig._internal() : this(null);
  
  TreeConfig(Accessor this._value, [Accessor this._children])
      : conditionalUlClasses = ((a, b) => ''),
        conditionalLiClasses = ((a, b) => ''),
        conditionalOpenedAtFirst = ((a, b) => false),
        conditionalUseIcons = ((a, b) => true),
        conditionalAlwaysOpened = ((a, b) => false),
        conditionalOnClick = ((a, b) => null);
  
  Accessor get value => _value;
  Accessor get children => _children;
}

class TreeNode extends TreeConfig {
  dynamic data;
  List<TreeNode> treeNodes;
  
  TreeNode(dynamic data, Accessor value) 
    : super(value, (TreeNode treeNode) => treeNode.treeNodes);
}

class TreeNodeDataWrapper {
  dynamic data;
  bool hasChildren;
  int length;
  int depth;
  int position;
  
  TreeNodeDataWrapper(this.data, this.hasChildren, this.length, this.depth, this.position);
  
  bool get isLast => length - 1 == position;
}

class Tree {
  static final String lastSiblingClass = 'dynatree-lastsib';
  
  // Main UL
  static final String defaultContainerClass = 'dynatree-container';
  static final String defaultConnectorsClass = 'dynatree-container-connector';
  
  // Expanders
  static final String defaultExpandedClass = 'dynatree-exp-e';
  static final String defaultExpandedLastSiblingClass = 'dynatree-exp-el';
  static final String defaultCollapsedClass = 'dynatree-exp-c';
  static final String defaultCollapsedLastSiblingClass = 'dynatree-exp-cl';
 
  // Icons
  static final String defaultExpandedFolderClass = 'dynatree-ico-ef';
  static final String defaultCollapsedFolderClass = 'dynatree-ico-cf';
  
  // Spans
  static final String defaultNodeClass = 'dynatree-node';
  static final String defaultConnectorClass = 'dynatree-connector';
  static final String defaultExpanderClass = 'dynatree-expander';
  static final String defaultIconClass = 'dynatree-icon';
  static final String defaultTextClass = 'dynatree-title';
  
  ExtElement _root;
  
  //List _data;
  List<TreeConfig> managers;
  Map dataAsMap;
  List _data;
  
  TreeConfig globalTreeConfig;
  bool _noFeature;
  
  // Features
  List<ExtElement> expandableElements;
  
  bool useDefaultCss;
  bool useConnectors; // Add defaultConnectorsClass
  String containerClass;
  String connectorsClass;
  
  bool closedAtStart;
  bool animate;
  bool sortable;
  
  Tree.noFeature([Accessor value, Accessor children]) : managers = new List(),
                                                        _noFeature = true,
                                                        useConnectors = false {
    if (value != null && children != null) {
      globalTreeConfig = new TreeConfig(value, children);
      managers.add(globalTreeConfig);
    } else {
      globalTreeConfig = new TreeConfig._internal();
    }
  }
  
  Tree([Accessor value, Accessor children]) : managers = new List(),
                                              expandableElements = new List(),
                                              dataAsMap = new Map(),
                                              _noFeature = false,
                                              useDefaultCss = true,
                                              useConnectors = true,
                                              closedAtStart = true,
                                              animate = false,
                                              sortable = false {
    if (value != null && children != null) {
      managers.add(new TreeConfig(value, children));
    }
  }
  
  Tree.custom() {
    _noFeature = false;
  }
  
  void addTreeConfig(TreeConfig nodeManager) {
    managers.add(nodeManager);
  }
  
  void addTo(var element, [String where = 'beforeEnd']) {
    final ExtElement parent = getExtElement(element);
    final ExtElement newList = buildUList(_data, managers);
    _root = newList;
    
    parent.insertAdjacentElement(where, newList.element);
    
    if (!_noFeature) {
      applyContainerStyle(newList);
      addDnd(newList);
    }
  }
  
  ExtElement buildUList(List data, List<TreeConfig> treeNodes, [final int depth = 0]) {
    final int depthIndex = depth != null && (treeNodes == null || depth < treeNodes.length) ? depth : 0;
    
    TreeConfig treeNode = treeNodes != null ? treeNodes[depthIndex] : null;
    ExtElement ul = null;
    
    if (isNotEmptyList(data)) {
      
      // <UL>
      final TreeNodeDataWrapper partialWrapper = new TreeNodeDataWrapper(null, null, data.length, depth, null);
      ul = buildUl(treeNode, partialWrapper);
      for (int i = 0; i < data.length; i++) {

        final element = data[i];
        
        if (treeNode == null) {
          treeNode = element;
        }
        
        List children;
        final bool hasChildren = treeNode.children != null && isNotEmptyList(children = treeNode.children(element));
        final TreeNodeDataWrapper wrapper = new TreeNodeDataWrapper(element, hasChildren, data.length, depth, i);
        
        // <LI>
        final ExtElement li = buildLi(treeNode, element, wrapper);
        ul.append(li.element);
        
        if (hasChildren) {
          // <UL> children
          final ExtElement ulChild = buildUList(children, treeNodes, depth + 1);
          if (ulChild != null) {
            li.append(ulChild.element);
            applyOnChildren(li, treeNode, element, wrapper);
          }
        }
        
        // Tranform a multiple level list into a plain map
        // ??
        if (!_noFeature) {
          if (treeNode._key != null) {
            this.dataAsMap[treeNode._key(element)] = element;
          } else {
            this.dataAsMap[treeNode._value(element)] = element;
          }
        }
      }
    }
    
    return ul;
  }

  ExtElement buildUl(TreeConfig treeNode, TreeNodeDataWrapper partialWrapper) {
    final ExtElement ul = new ExtElement(new UListElement());
    ul.addClasses(treeNode.conditionalUlClasses(treeNode, partialWrapper));
    return ul;
  }
  
  ExtElement buildLi(TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    final ExtElement li = new ExtElement(new LIElement());
    li.addClasses(treeNode.conditionalLiClasses(treeNode, wrapper));
    
    if (_noFeature) {
      li.text = treeNode.value(data);
    } else {
      addFeaturesToLi(li, treeNode, data, wrapper);
    }
      
    return li;
  }
  
  void applyContainerStyle(ExtElement rootUl) {
    if (containerClass == null) {
      if (useDefaultCss) {
        rootUl.addClasses(defaultContainerClass);
      }
    } else {
      rootUl.addClasses(containerClass);
    }

    if (useConnectors) {
      if (connectorsClass == null) {
        if (useDefaultCss) {
          rootUl.addClasses(defaultConnectorsClass);
        }
      } else {
        rootUl.addClasses(connectorsClass);
      }
    }
  }
  
  void addFeaturesToLi(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    if (wrapper.isLast) {
      li.classes.add(lastSiblingClass);
    }
    
    addSpanWrapper(li, treeNode, data, wrapper);
    addConnections(li, treeNode, data, wrapper);
    addIcons(li, treeNode, data, wrapper);
    addTitle(li, treeNode, data, wrapper);
    addExpandCollapse(li, treeNode, data, wrapper);
    addOnClick(li, treeNode, data, wrapper);
    //addOnClick(li, treeNode, data, wrapper);
  }
  
  void addSpanWrapper(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    final SpanElement node = new SpanElement();
    li.append(node);
  }

  void addConnections(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    if (useConnectors) {
      // Choice between Connector & Expander
      final String connectionClass = wrapper.hasChildren && !treeNode.conditionalAlwaysOpened(data, wrapper)
                                                              ? defaultExpanderClass : defaultConnectorClass;
      final SpanElement connector = new SpanElement();
      connector.classes.add(connectionClass);
      li.children[0].append(connector);
      
      if (wrapper.hasChildren) {
        String connectorStateClass;
        
        if (!closedAtStart || treeNode.conditionalOpenedAtFirst(data, wrapper)) {
           connectorStateClass = !wrapper.isLast ? defaultExpandedClass : defaultExpandedLastSiblingClass;
        } else {
          connectorStateClass = !wrapper.isLast ? defaultCollapsedClass : defaultCollapsedLastSiblingClass;
        }
        
        li.children[0].classes.add(connectorStateClass);
      }
    }
  }

  void addIcons(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    if (treeNode.conditionalUseIcons(data, wrapper)) {
      final SpanElement icon = new SpanElement();
      icon.classes.add(defaultIconClass);
      li.children[0].append(icon);
      
      String clazz;
      if (wrapper.hasChildren) {// && nm.conditionalClosable(t, hasChildren, lastSibling, depth - 1)) {
        if ((!closedAtStart || treeNode.conditionalOpenedAtFirst(data, wrapper))
                            || treeNode.conditionalAlwaysOpened(data, wrapper)) {
          clazz = defaultExpandedFolderClass;
        } else {
          clazz = defaultCollapsedFolderClass;
        }
      }
      
      if (clazz != null) {
        li.children[0].classes.add(clazz);
      }
    }
  }
  
  void addTitle(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    final SpanElement span = new SpanElement();
    span.classes.add(defaultTextClass);
    
    final value = treeNode._value(data);
    if (value is Element) {
      span.append(value);
    } else if (value is PwtElement) {
      value.addTo(span);
    } else {
      span.text = value.toString();
    }
    li.children[0].append(span);
  }

  void addExpandCollapse(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    if (wrapper.hasChildren && !treeNode.conditionalAlwaysOpened(data, wrapper)) {
      li.children[0].onClick.listen((MouseEvent e) {
        final ExtElement extLi = getExtElement(li);
        
        // <li><span><span>Text
        final SpanElement span = li.children[0];
        final ExtElement extSpan = getExtElement(span);
        
        // Change Classes
        if (extLi.hasClass(lastSiblingClass)) {
          extSpan.toggleClasses('$defaultExpandedLastSiblingClass $defaultCollapsedLastSiblingClass');
        } else {
          extSpan.toggleClasses('$defaultExpandedClass $defaultCollapsedClass');
        }
        
        extSpan.toggleClasses('$defaultCollapsedFolderClass $defaultExpandedFolderClass');
        
        // Toggle
        final ExtElement extLiChild = getExtElement(li.children[1]);
        
        if (animate) {
          slideToggle(extLiChild.element, null, new SlideOptions(onComplete: (_) => extLiChild.style.height = ''));
        } else {
          extLiChild.toggle();
        }
        
        expandableElements.add(extLiChild);
        
        // Parents listen to onclick too!
        e.stopPropagation();
      });
    }
  }
  
  void addOnClick(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    OnTreeAction action = treeNode.conditionalOnClick(data, wrapper); //(null, data, wrapper);
    //action;
    if (action != null) {
      li.children[0].onClick.listen((MouseEvent e) => action(e, data, wrapper)); 
    }
  }
  
  void addDnd(ExtElement ulRoot) {
    if (sortable) {
      new SortableTree(ulRoot); //..onSort((SortEvent event) => window.alert(event.sortable.text));
    }
  }
  
  void applyOnChildren(ExtElement li, TreeConfig treeNode, dynamic data, TreeNodeDataWrapper wrapper) {
    if (!_noFeature && wrapper.hasChildren && (closedAtStart && !treeNode.conditionalOpenedAtFirst(data, wrapper))
                                              && !treeNode.conditionalAlwaysOpened(data, wrapper)) {
      li.children[1].style.display = 'none';
    }
  }
  
  void expand() {
    expandableElements.forEach((ExtElement e) => e.show());
  }
  
  void collapse() {
    expandableElements.forEach((ExtElement e) => e.hide());
  }
  
  /*
  List get data {
    if (sortable) {
      _data.clear();
      
      _data = reverseList(_root);
      
      return _data;
    } else {
      return _data;
    }
  }
  */
    set data(List data) => _data = data;
    
  List reverseList(ExtElement element) {
    List list;
    
    
  }
}