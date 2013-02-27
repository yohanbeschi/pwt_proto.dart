import 'animation/pwt_animation_test.dart';
import 'css/pwt_proto_test.dart';
import 'utils/pwt_utils_test.dart';

void main() {
  int tests = 0;
  int exceptions = 0;
  final List list = [//string_utils
                     isEmptyTest,
                     camelCaseTest1,
                     camelCaseTest2,
                     uncamelTest1,
                     uncamelTest2,
                     //number_utils
                     inRangeTest1,
                     inRangeTest2,
                     inRangeTest3, 
                     inRangeTest4,
                     inRangeAsIntTest1,
                     inRangeAsIntTest2,
                     parseNumberTest1,
                     parseNumberTest2,
                     parseNumberTest3,
                     //css_utils
                     hasUnitsTest1,
                     hasUnitsTest2,
                     hasUnitsTest3,
                     hasUnitsTest4,
                     parseUnitTest1,
                     parseUnitTest2,
                     parseSizeTest1,
                     parseSizeTest2,
                     parseDSizeTest1,
                     parseDSizeTest2,
                     allowsNegativeTest1,
                     allowsNegativeTest2,
                     colorFromRgbTest1,
                     colorFromRgbTest2,
                     colorFromHexSixTest1,
                     colorFromHexThreeTest1,
                     colorFromHexThreeTest2,
                     parseColorTest1,
                     parseColorTest2,
                     parseColorTest3,
                     //std_objs
                     colorToString1,
                     colorToString2,
                     sizeToString1,
                     dSizeToString1,
                     //animation_utils
                     buildNumTest1,
                     buildColorTest1,
                     buildSizeTest1,
                     buildSizeInRangeTest1,
                     buildSizeInRangeTest2,
                     buildDsizeTest1,
                     //animation_queue_test
                     addToQueueTest1,
                     addToQueueTest2,
                     removeFromQueueTest1,
                     removeFromQueueTest2,
                     processQueueTest1,
                     processQueueTest2,
                     processQueueTest3];
  
  for (Function f in list) {
    try {
      tests++;
      f();
    } catch(e) {
      print(e);
      exceptions++;
    }
  }
  
  if (exceptions == 0) {
    print('========================> $tests/$tests Tests successful');
  } else {
    print('========================> $exceptions/$tests Tests KO');
  }
}