part of pwt_animation;

void tearDown(List<Animation> animations) {
  _manager._timer = null;
  _manager._queue.clear();
}

void addToQueueTest1() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
      
  // At start up
  assert(_manager._queue.length == 0);
  assert(_manager._intervalTime != null);
  assert(_manager._timer != null);
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions();
  final AnimationMock anim = new AnimationMock(null, 1, null, options);
  _manager._addToQueue(anim);
  assert(_manager._queue.length == 1);
  assert(_manager._timer == timer);
  assert(_manager._intervalTime != null);
  assert(anim._playing);
  assert(anim._timeAnchor != null);
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 1);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  
  tearDown([anim]);
}

void addToQueueTest2() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
      
  // At start up
  assert(_manager._queue.length == 0);
  assert(_manager._intervalTime != null);
  assert(_manager._timer != null);
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions();
  final AnimationMock anim = new AnimationMock(null, 1, null, options);
  _manager._addToQueue(anim);
  // Adding a second animation to the queue
  final AnimationOptions options2 = new AnimationOptions();
  final AnimationMock anim2 = new AnimationMock(null, 3, null, options2);
  _manager._addToQueue(anim2);
  assert(_manager._queue.length == 2);
  assert(_manager._timer == timer);
  assert(_manager._intervalTime != null);
  //------Anim 1
  assert(anim._playing);
  assert(anim._timeAnchor != null);
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 1);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  //------Anim 2
  assert(anim2._playing);
  assert(anim2._timeAnchor != null);
  assert(anim2.invokedMethodCount == 0);
  //----Untouched
  assert(anim2._options == options2);
  assert(anim2._duration == 3);
  assert(anim2._position == 0);
  assert(anim2._progress == 0);
  assert(anim2._element == null);
  
  tearDown([anim, anim2]);
}

void removeFromQueueTest1() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions();
  final AnimationMock anim = new AnimationMock(null, 1, null, options);
  _manager._addToQueue(anim);
  // Adding a second animation to the queue
  final AnimationOptions options2 = new AnimationOptions();
  final AnimationMock anim2 = new AnimationMock(null, 3, null, options2);
  _manager._addToQueue(anim2);
  
  assert(_manager._queue.length == 2);
  assert(_manager._timer == timer);
  assert(_manager._intervalTime != null);
  
  _manager._removeFromQueue(anim);
  
  assert(_manager._queue.length == 1);
  assert(_manager._timer == timer);
  assert(_manager._intervalTime != null);
  
  //------Anim 1
  assert(!anim._playing); // Changed
  assert(anim._timeAnchor == null); // Changed
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 1);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  //------Anim 2
  assert(anim2._playing);
  assert(anim2._timeAnchor != null);
  assert(anim2.invokedMethodCount == 0);
  //----Untouched
  assert(anim2._options == options2);
  assert(anim2._duration == 3);
  assert(anim2._position == 0);
  assert(anim2._progress == 0);
  assert(anim2._element == null);
  
  tearDown([anim, anim2]);
}

void removeFromQueueTest2() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions();
  final AnimationMock anim = new AnimationMock(null, 1, null, options);
  _manager._addToQueue(anim);
  // Adding a second animation to the queue
  final AnimationOptions options2 = new AnimationOptions();
  final AnimationMock anim2 = new AnimationMock(null, 3, null, options2);
  _manager._addToQueue(anim2);
  
  assert(_manager._queue.length == 2);
  
  _manager._removeFromQueue(anim2);
  _manager._removeFromQueue(anim);
  
  assert(_manager._queue.length == 0);
  assert(_manager._timer == null);
  assert(_manager._intervalTime != null);
  
  //------Anim 1
  assert(!anim._playing); // Changed
  assert(anim._timeAnchor == null); // Changed
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 1);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  //------Anim 2
  assert(!anim2._playing);  // Changed
  assert(anim2._timeAnchor == null);  // Changed
  assert(anim2.invokedMethodCount == 0);
  //----Untouched
  assert(anim2._options == options2);
  assert(anim2._duration == 3);
  assert(anim2._position == 0);
  assert(anim2._progress == 0);
  assert(anim2._element == null);
  
  tearDown([anim, anim2]);
}

void processQueueTest1() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions();
  final AnimationMock anim = new AnimationMock(null, 1, null, options);
  _manager._addToQueue(anim);
  
  assert(_manager._queue.length == 1);
  
  assert(anim._playing);
  assert(anim._timeAnchor != null);
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 1);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  
  _manager._processQueue(_manager._timer);

  assert(anim._duration == 1);
  assert(anim._position == 0); // Still 0
  assert(anim._progress == anim._position / anim._duration);
  assert(anim._element == null);
  assert(anim.invokedStart == 0);
  assert(anim.invokedStop == 0);
  assert(anim.invokedComplete == 0);
  assert(anim.invokedResume == 0);
  assert(anim.invokedAction == 1);
  
  tearDown([anim]);
}

void processQueueTest2() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions(useSeconds:false);
  final AnimationMock anim = new AnimationMock(null, 1, null, options);
  _manager._addToQueue(anim);
  
  assert(_manager._queue.length == 1);
  
  assert(anim._playing);
  assert(anim._timeAnchor != null);
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 1);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  
  _manager._processQueue(_manager._timer);

  assert(anim._duration == 1);
  assert(anim._position == 1);
  assert(anim._progress == anim._position / anim._duration);
  assert(anim._element == null);
  assert(anim.invokedStart == 0);
  assert(anim.invokedStop == 0);
  assert(anim.invokedComplete == 0);
  assert(anim.invokedResume == 0);
  assert(anim.invokedAction == 1);
  
  tearDown([anim]);
}

void processQueueTest3() {
  // Block processing queue
  final Timer timer = new Timer(new Duration(milliseconds:10), () {});
  _manager._timer = timer;
  
  // Adding an animation to the queue
  final AnimationOptions options = new AnimationOptions(destroyOnComplete:true, useSeconds:false);
  final AnimationMock anim = new AnimationMock(null, 10, null, options);
  _manager._addToQueue(anim);
  
  assert(_manager._queue.length == 1);
  
  assert(anim._playing);
  assert(anim._timeAnchor != null);
  assert(anim.invokedMethodCount == 0);
  //----Untouched
  assert(anim._options == options);
  assert(anim._duration == 10);
  assert(anim._position == 0);
  assert(anim._progress == 0);
  assert(anim._element == null);
  
  int count = 0;
  while(_manager._queue.length == 1) {
    _manager._processQueue(_manager._timer);
    count++;
  }

  assert(anim._duration == 10);
  assert(anim._position == count - 1);
  assert(anim._progress == anim._position / anim._duration);
  assert(anim._element == null);
  assert(anim.invokedStart == 0);
  assert(anim.invokedStop == 0);
  assert(anim.invokedComplete == 1);
  assert(anim.invokedResume == 0);
  assert(anim.invokedAction == count - 1);
  
  tearDown([anim]);
}

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
  final num _duration;
  
  //Seconds since starting, or current frame.
  num _position = 0;
  
  /* Current tweened value of the animation, usually between 0 & 1.
   * The value may become greater than 1 or less than 0 depending on the tween used.
   * 
   * [elasticOut()] for instance will result in values higher than 1, but will still end at 1.
   */
  num _progress = 0;
  
  Element _element;
  
  // Used by timeline
  double _timelineOffset;
  
  int invokedMethodCount = 0;
  int invokedStart = 0;
  int invokedStop = 0;
  int invokedComplete = 0;
  int invokedResume = 0;
  int invokedAction = 0;
  
  AnimationMock(Element this._element, num this._duration, Map properties, AnimationOptions this._options) {
    this._setAction(properties);
    this._addListeners();
  }
  
  void start() {
    invokedMethodCount++;
  }
  
  void stop() {
    invokedMethodCount++;
  }
  
  void destroy() {
    invokedMethodCount++;
  }
  
  void resume() {
    invokedMethodCount++;
  }
  
  bool get playing => false;
  
  void  goTo(num position) {
    invokedMethodCount++;
  }
  
  num get progress => _progress;
  
  void _setAction(Map<String, dynamic> properties) {
  }
  
  void _addListeners() {
    _animationStartController.stream.listen((Animation anim) => invokedStart++);
    _animationStopController.stream.listen((Animation anim) => invokedStop++);
    _animationCompleteController.stream.listen((Animation anim) => invokedComplete++);
    _animationResumeController.stream.listen((Animation anim) => invokedResume++);
    _animationActionController.stream.listen((Animation anim) => invokedAction++);
  }

}