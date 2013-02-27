part of pwt_animation;

typedef void AnimationAction(Animation animation);

class AnimationOptions {
  // Indicates whether duration is in seconds rather than frames.
  bool _useSeconds;
  //The tween used by the animation.
  Tween _tween;
  bool _destroyOnComplete = false;
  
  AnimationAction _onStart = null;
  AnimationAction _onStop = null;
  AnimationAction _onComplete = null;
  AnimationAction _onResume = null;
  AnimationAction _onAction = null;

  AnimationOptions({bool useSeconds, 
                    Tween tween, 
                    bool destroyOnComplete,
                    AnimationAction onStart,
                    AnimationAction onStop,
                    AnimationAction onComplete,
                    AnimationAction onAction,
                    AnimationAction onResume}) {
    if (useSeconds == null) {
      this._useSeconds = true;
    } else {
      this._useSeconds = useSeconds;
    }
    
    if (tween == null) {
      this._tween = linear();
    } else {
      this._tween = tween;
    }
    
    if (destroyOnComplete == null) {
      this._destroyOnComplete = false;
    } else {
      this._destroyOnComplete = destroyOnComplete;
    }
    
    this._onStart = onStart;
    this._onStop = onStop;
    this._onComplete = onComplete;
    this._onAction = onAction;
    this._onResume = onResume;
  }
}

class Animation {
  final StreamController<Animation> _animationStartController = new StreamController.broadcast();
  final StreamController<Animation> _animationStopController = new StreamController.broadcast();
  final StreamController<Animation> _animationCompleteController = new StreamController.broadcast();
  final StreamController<Animation> _animationActionController = new StreamController.broadcast();
  final StreamController<Animation> _animationResumeController = new StreamController.broadcast();

  static final Unit DEFAULT_UNIT = Unit.PX;
  
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
  
  Animation.duration(num this._duration) {
   this._options = new AnimationOptions(); 
   this._options._onAction = (_) => _;
  }
  
  Animation(Element this._element, num this._duration, Map properties, [AnimationOptions options]) {
    if (options == null) {
      this._options = new AnimationOptions();
    } else {
      this._options = options;
    }
    
    this._setAction(properties);
    this._addListeners();
  }
  
  /**
   * Starts playing the animation from the beginning.
   */
  void start() {
    if (this._playing) {
      this.stop();
    }

    _animationStartController.add(this);
    this._timeAnchor = null;
    this._position = 0;
    _manager._addToQueue(this);
  }
  
  /**
   * Stops the animation playing.
   */
  void stop() {
    if (this._playing) {
      _animationStopController.add(this);
      _manager._removeFromQueue(this);
    }
  }
  
  void destroy() {
    // stop the animation in case it's still playing
    this.stop();
  }

  void resume() {
    if (!this.playing) {
      _animationResumeController.add(this);
      
      //set the start time to cater for the pause
      this._timeAnchor = (new DateTime.now().millisecondsSinceEpoch - (this._position * 1000)).toInt();
      _manager._addToQueue(this);
    }
  }
  
  /**
   * Returns true if the animation is playing.
   */
  bool get playing => this._playing;
  
  void  goTo(num position) {
    this._position = position;
    this._timeAnchor = new DateTime.now().millisecondsSinceEpoch - (position * 1000);
    this._progress = this._options._tween(this._position / this._duration);
    this._animationActionController.add(this);
  }
  
  void _setAction(Map<String, dynamic> properties) {
    _animationActionController.stream.listen(_buildAction(this._element, properties));
  }

  num get progress => this._progress;
  
  void _addListeners() {
    if (this._options._onStart != null) {
      _animationStartController.stream.listen(this._options._onStart);
    }
    
    if (this._options._onStop != null) {
      _animationStopController.stream.listen(this._options._onStop);
    }
    
    if (this._options._onComplete != null) {
      _animationCompleteController.stream.listen(this._options._onComplete);
    }
    
    if (this._options._onResume != null) {
      _animationResumeController.stream.listen(this._options._onResume);
    }
    
    if (this._options._onAction != null) {
      _animationActionController.stream.listen(this._options._onAction);
    }
  }
}

AnimationAction _buildAction(Element element, Map<String, dynamic> properties) {
  final List<AnimationAction> list = new List();
  properties.forEach((key, value) => list.add(_buildAnimation(element, key, value)));
  
  return (Animation animation) 
      => list.forEach((AnimationAction animationAction) => animationAction(animation));
}

AnimationAction _buildAnimation(Element element, String propertyName, dynamic data) {
  propertyName = uncamel(propertyName);

  if (hasUnits(propertyName)) {
    return _parseAnimateSize(element, propertyName, data);
  } else if (propertyName.contains('color')) {
    return _parseAnimateColor(element, propertyName, data);
  } else if ('background-position' == propertyName) {
    return _parseAnimateDSize(element, propertyName, data);
  } else {
    return _parseAnimateNumber(element, propertyName, data);
  }
}

AnimationAction _parseAnimateNumber(Element element, String propertyName, dynamic data)
  => _parse(element, propertyName, 0, data, parseNumber, _animateNumber);

AnimationAction _parseAnimateColor(Element element, String propertyName, dynamic data)
  => _parse(element, propertyName, new Color(0,0,0), data, parseColor, _animateColor);

AnimationAction _parseAnimateSize(Element element, String propertyName, dynamic data)
=> _parse(element, propertyName, new Size(0, Unit.PX), data, parseSize, _animateSize);


AnimationAction _parseAnimateDSize(Element element, String propertyName, dynamic data) 
  => _parse(element, propertyName, new DSize(new Size(0, Unit.PX), new Size(0, Unit.PX)), data, parseDSize, _animateDSize);

//TODO: Size with different Units
AnimationAction _parse(Element element, String propertyName, dynamic defaultFrom, dynamic data, Function parser, Function animator) {
  var from = null;
  var to = null;
  
  if (data is Map) {
    from = parser(data['from']);
    to = parser(data['to']);
  } else {
    final String fromStr = element.getComputedStyle().getPropertyValue(propertyName);
    from = isNotBlank(fromStr) ? parser(fromStr) : defaultFrom;
    to = parser(data);
  }
  
  return animator(element, propertyName, from, to);
}

AnimationAction _animateNumber(Element element, String propertyName, num from, num to)
  => _animator(element, propertyName, from, to, buildNum);

AnimationAction _animateColor(Element element, String propertyName, Color from, Color to)
  => _animator(element, propertyName, from, to, buildColor);
      
AnimationAction _animateSize(Element element, String propertyName, Size from, Size to) {
  if (allowsNegative(propertyName)) {
    return _animator(element, propertyName, from, to, buildSize);
  } else {
    return _animator(element, propertyName, from, to, buildSizeInRange);
  }
}

AnimationAction _animateDSize(Element element, String propertyName, DSize from, DSize to)
  => _animator(element, propertyName, from, to, buildDsize);

AnimationAction _animator(Element element, String propertyName, dynamic from, dynamic to, Function builder)
  => (Animation a)
    => element.style.setProperty(propertyName, builder(a.progress, from, to));