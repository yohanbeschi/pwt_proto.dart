library pwt_animation;

import 'dart:async';
import 'dart:collection';
import 'dart:math';
import '../css/pwt_proto_test.dart';
import '../../../lib/utils/pwt_utils.dart';

part '../../../lib/animation/src/animation.dart';
part '../../../lib/animation/src/animation_queue.dart';
part '../../../lib/animation/src/animation_utils.dart';
part '../../../lib/animation/src/tweens.dart';
part 'src/animation_queue_test.dart';
part 'src/animation_utils_test.dart';

// For Animation class
class Element {
  Css style;
  
  Css getComputedStyle() {
    return new Css();
  }
  
  
}

class Css {
  String getPropertyValue(String property) {
    return "";
  }
  
  void setProperty(String property, String value) {
    
  }
}