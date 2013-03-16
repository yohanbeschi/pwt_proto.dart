import 'dart:html';
import 'dart:json';
import '../lib/css/pwt_css.dart';

void main() {
  final List<Fragment> frags = [new Fragment('hasClass', 'frags/has_class.html'),
                                new Fragment('addClasses', 'frags/add_classes.html'),
                                new Fragment('toggleClasses', 'frags/toggle_classes.html'),
                                new Fragment('css', 'frags/css.html'),
                                new Fragment('isVisible', 'frags/is_visible.html'),
                                new Fragment('showHide', 'frags/show_hide.html'),
                                new Fragment('toggle', 'frags/toggle.html'),
                                new Fragment('heightWidth', 'frags/height_width.html'),
                                new Fragment('slide', 'frags/slide.html'),
                                new Fragment('fade', 'frags/fade.html'),
                                new Fragment('animation', 'frags/animation.html'),
                                new Fragment('timeline', 'frags/timeline.html'),
                                new Fragment('shadow', 'frags/shadow.html'),
                                new Fragment('drag', 'frags/drag.html'),
                                new Fragment('drop', 'frags/drop.html'),
                                new Fragment('sortable', 'frags/sortable.html'),
                                new Fragment('resizable', 'frags/resizable.html'),
                                new Fragment('mask', 'frags/mask.html')
                                ];
  
  final Element container = query('#container');
  
  frags.forEach((frag) => container.append(buildIframe(frag)));
  
  // Resize notification
  window.onMessage.listen((MessageEvent me) {
      final Map<String, String> map = parse(me.data);
      final IFrameElement e = query('#${map['id']}');
      e.height = map['height'];
      //e.width = '1000';
  });
}

Element buildIframe(final Fragment frag) {
  final String d = '<iframe seamless id="${frag.id}" src="${frag.src}" width="1200" height="500">';
  
  return new Element.html(d);
}

class Fragment {
  final String id;
  final String src;
  
  Fragment(this.id, this.src);
}