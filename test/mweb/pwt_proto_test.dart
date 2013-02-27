import 'dart:html';
import 'dart:json';
import '../../lib/css/pwt_css.dart';

void main() {
  final List<Fragment> frags = [new Fragment('hasClass', 'frags/has_class.html'),
                                new Fragment('addClasses', 'frags/add_classes.html'),
                                new Fragment('', 'frags/toggle_classes.html'),
                                new Fragment('', 'frags/is_visible.html'),
                                new Fragment('', 'frags/show_hide.html'),
                                new Fragment('', 'frags/toggle.html'),
                                new Fragment('', 'frags/height_width.html')];
  
  final Element container = query('#container');
  
  frags.forEach((frag) => container.append(buildIframe(frag)));
  
  // Resize notification
  window.onMessage.listen((MessageEvent me) {
      final Map<String, String> map = parse(me.data);
      final IFrameElement e = query(map['id']);
      e.height = map['height'];
      e.width = '*';
  });
}

Element buildIframe(final Fragment frag) {
  final String d = '<iframe seamless id="${frag.id}" src="${frag.src}">';
  
  return new Element.html(d);
}

class Fragment {
  final String id;
  final String src;
  
  Fragment(this.id, this.src);
}