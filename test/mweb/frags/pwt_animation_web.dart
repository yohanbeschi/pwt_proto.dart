library pwt_animation;

import 'dart:async';
import 'dart:collection';
import 'dart:html';
import 'dart:math';
import '../../../lib/pwt/pwt.dart';
import '../../../lib/css/pwt_css.dart';
import '../../../lib/utils/pwt_utils.dart';

part '../../../lib/animation/src/animate.dart';
part '../../../lib/animation/src/animation.dart';
part '../../../lib/animation/src/animation_queue.dart';
part '../../../lib/animation/src/animation_utils.dart';
part '../../../lib/animation/src/timeline.dart';
part '../../../lib/animation/src/tweens.dart';
part 'animation_test.dart';


void main() {
  //--------------------------------------------------------------------------------------------------------------------
  // _animate
  //--------------------------------------------------------------------------------------------------------------------
  //---- Opacity
  $('#changeOpacityButton').onClick.listen((e) {
    final AnimationAction animationAction = _animateNumber(query('#box0'), 'opacity', 1, 0);
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Width
  $('#changeWidthButton').onClick.listen((e) {
    final AnimationAction animationAction = _animateSize(query('#box1'), 'width', 
                                                  new Size(50, Unit.PX), new Size(150, Unit.PX));
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Margin
  $('#changeMarginLeftButton').onClick.listen((e) {
    final AnimationAction animationAction = _animateSize(query('#box2'), 'margin-left', 
                                                  new Size(0, Unit.PX), new Size(25, Unit.PX));
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Color
  $('#changeColorButton').onClick.listen((e) {
    final AnimationAction animationAction = _animateColor(query('#box3'), 'background-color', 
                                                  new Color(255,255,255), new Color(0,0,0));
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- background
  $('#moveBgButton').onClick.listen((e) {
    final AnimationAction animationAction = _animateDSize(query('#box4'), 'background-position', 
                                                  new DSize(new Size(0, Unit.PX), new Size(0, Unit.PX)), 
                                                  new DSize(new Size(-20, Unit.PX), new Size(-20, Unit.PX)));
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //--------------------------------------------------------------------------------------------------------------------
  // _parse
  //--------------------------------------------------------------------------------------------------------------------
  //---- Opacity
  $('#changeOpacityButton2').onClick.listen((e) {
    final AnimationAction animationAction = _parseAnimateNumber(query('#box02'), 'opacity', {'from':1, 'to':0});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Width
  $('#changeWidthButton2').onClick.listen((e) {
    final AnimationAction animationAction = _parseAnimateSize(query('#box12'), 'width', '150px');
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Margin
  $('#changeMarginLeftButton2').onClick.listen((e) {
    final AnimationAction animationAction = _parseAnimateSize(query('#box22'), 'margin-left', 
                                                              {'from':'0px', 'to':'25px'});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Color
  $('#changeColorButton2').onClick.listen((e) {
    final AnimationAction animationAction = _parseAnimateColor(query('#box32'), 'background-color', '#000');
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- background
  $('#moveBgButton2').onClick.listen((e) {
    final AnimationAction animationAction = _parseAnimateDSize(query('#box42'), 'background-position', 
                                                                    {'from':'0px 0px', 'to':'-20px -20px'});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //--------------------------------------------------------------------------------------------------------------------
  // _buildAnimation
  //--------------------------------------------------------------------------------------------------------------------
  //---- Opacity
  $('#changeOpacityButton3').onClick.listen((e) {
    final AnimationAction animationAction = _buildAnimation(query('#box03'), 'opacity', {'from':1, 'to':0});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Width
  $('#changeWidthButton3').onClick.listen((e) {
    final AnimationAction animationAction = _buildAnimation(query('#box13'), 'width', '150px');
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Margin
  $('#changeMarginLeftButton3').onClick.listen((e) {
    final AnimationAction animationAction = _buildAnimation(query('#box23'), 'margin-left', 
                                                              {'from':'0px', 'to':'25px'});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- Color
  $('#changeColorButton3').onClick.listen((e) {
    final AnimationAction animationAction = _buildAnimation(query('#box33'), 'background-color', '#000');
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //---- background
  $('#moveBgButton3').onClick.listen((e) {
    final AnimationAction animationAction = _buildAnimation(query('#box43'), 'background-position', 
                                                                    {'from':'0px 0px', 'to':'-20px -20px'});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //--------------------------------------------------------------------------------------------------------------------
  // _buildAction
  //--------------------------------------------------------------------------------------------------------------------
  $('#multipleModifications').onClick.listen((e) {
    final AnimationAction animationAction = _buildAction(query('#box04'), 
         {'opacity': {'from':1, 'to':0},
          'width': '150px',
          'margin-left': {'from':'0px', 'to':'25px'},
          'background-position':'-20px -20px'});
    
    final Animation anim = new AnimationMock();
    animationAction(anim);
  });
  
  //--------------------------------------------------------------------------------------------------------------------
  // Animation
  //--------------------------------------------------------------------------------------------------------------------
  $('#animation1').onClick.listen((e) {
    final Animation anim = new Animation(query('#box05'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());
    anim.start();
    final Animation anim2 = new Animation(query('#box15'), 10,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());
    anim2.start();
  });
  
  //--------------------------------------------------------------------------------------------------------------------
  // Timeline
  //--------------------------------------------------------------------------------------------------------------------
  $('#timeline1').onClick.listen((e) {
    final Animation anim = new Animation(query('#box06'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Animation anim2 = new Animation(query('#box16'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Timeline t = new Timeline([[anim],[anim2]], new TimelineOptions());
    t.start();
  });
  
  $('#timeline2').onClick.listen((e) {
    final Animation anim = new Animation(query('#box07'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Animation anim2 = new Animation(query('#box17'), 3,
        {'opacity': {'from':1, 'to':0},
         'width': '150px',
         'margin-left': {'from':'0px', 'to':'25px'},
         'background-position':'-20px -20px'}, new AnimationOptions());

    final Timeline t = new Timeline([[anim, anim2]], new TimelineOptions());
    t.start();
  });
}