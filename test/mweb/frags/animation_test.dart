part of pwt_animation;

class AnimationMock implements Animation {
  final StreamController<Animation> _animationStartController = new StreamController.broadcast();
  final StreamController<Animation> _animationStopController = new StreamController.broadcast();
  final StreamController<Animation> _animationCompleteController = new StreamController.broadcast();
  final StreamController<Animation> _animationActionController = new StreamController.broadcast();
  final StreamController<Animation> _animationResumeController = new StreamController.broadcast();
  
  AnimationOptions _options;
  
  //Indicates whether the animation is playing.
  bool _playing = false;
  
  //A timestamp used to keep the animation in the right position.
  int _timeAnchor = null;
  
  //Length of the animation in seconds / frames.
  final num _duration = 0;
  
  //Seconds since starting, or current frame.
  num _position = 0;
  
  /* Current tweened value of the animation, usually between 0 & 1.
   * The value may become greater than 1 or less than 0 depending on the tween used.
   * 
   * [elasticOut()] for instance will result in values higher than 1, but will still end at 1.
   */
  num _progress = 0;
  
  Element _element;

  double _timelineOffset;
  
  void start() {

  }
  
  void stop() {
    
  }
  
  void destroy() {
    
  }
  
  void resume() {
    
  }
  
  bool get playing => false;
  
  void  goTo(num position) {
    
  }
  
  num get progress => 0.83;
  
  void _setAction(Map<String, dynamic> properties) {
    
  }
  
  void _addListeners() {
    
  }

}