part of pwt_animation;

typedef void TimelineAction(Timeline timeline);

class TimelineOptions {
  bool _loop;
  bool _destroyOnComplete;

  TimelineAction _onStart;
  TimelineAction _onStop;
  TimelineAction _onComplete;
  TimelineAction _onResume;

  TimelineOptions({bool loop,
                bool destroyOnComplete,
                TimelineAction onStart,
                TimelineAction onStop,
                TimelineAction onComplete,
                TimelineAction onResume}) {
    if (loop == null) {
      this._loop = false;
    } else {
      this._loop = loop;
    }
    
    if (destroyOnComplete == null) {
      this._destroyOnComplete = false;
    } else {
      this._destroyOnComplete = destroyOnComplete;
    }
    
    if (destroyOnComplete == null) {
      this._destroyOnComplete = false;
    } else {
      this._destroyOnComplete = destroyOnComplete;
    }
    
    this._onStart = onStart;
    this._onStop = onStop;
    this._onComplete = onComplete;
    this._onResume = onResume;
  }
}

class Timeline {
  final StreamController<Timeline> _timelineStartController = new StreamController.broadcast();
  final StreamController<Timeline> _timelineStopController = new StreamController.broadcast();
  final StreamController<Timeline> _timelineCompleteController = new StreamController.broadcast();
  final StreamController<Timeline> _timelineResumeController = new StreamController.broadcast();
  
  TimelineOptions _options;
  
  // List of channels, containing a list of animations
  List<List<Animation>> _channels;
  
  // Index of each currently playing animation
  List<int> _channelPos;
  
  // Is the timeline playing?
  bool _playing = false;
  
  // The timeline is considered as an animation to keep it in time
  Animation _timelineAnimation;
  
  // Length of the animation in seconds ()
  double _duration;
  
  Timeline(List<List<dynamic>> channels, [TimelineOptions options]) {
    if (options == null) {
      this._options = new TimelineOptions();
    } else {
      this._options = options;
    }
    
    _buildTimeline(channels);
    _addListenersToTimeline();
    _addListenersToAnimation();
  }

  StreamSubscription<Timeline> onStart(TimelineAction timelineAction) 
    => this._timelineStartController.stream.listen(timelineAction);
  
  StreamSubscription<Timeline> onStop(TimelineAction timelineAction) 
    => this._timelineStopController.stream.listen(timelineAction);
  
  StreamSubscription<Timeline> onComplete(TimelineAction timelineAction) 
    => this._timelineCompleteController.stream.listen(timelineAction);
  
  StreamSubscription<Timeline> onResume(TimelineAction timelineAction) 
    => this._timelineResumeController.stream.listen(timelineAction);
  
  /**
   * Returns true if the timeline is playing.
   */
  bool get playing => this._playing;
  
  void _buildTimeline(List<List<dynamic>> channels) {
    this._channels = new List();
    
    double totalDuration = 0.0;
    
    
    for (List<dynamic> channel in channels) {
      final List<Animation> animations = new List();
      
      double channelDuration = 0.0;
      //int channelIndex = 0;
      for (dynamic anim in channel) {
        //create a blank animation for time waiting
        if (anim is num) {
          final Animation animation = new Animation.duration(anim);
          animations.add(animation);
          animation._timelineOffset = channelDuration * 1000;
          channelDuration += animation._duration;
        } else if (anim is Animation) {
          animations.add(anim);
          if (!anim._options._useSeconds) {
            throw new Error(); //"Timelined animations must be timed in seconds"
          }
          
          anim._timelineOffset = channelDuration * 1000;
          channelDuration += anim._duration;
        }
      }
      
      this._channels.add(animations);
      totalDuration = max(channelDuration, totalDuration);
    }
    
    this._duration = totalDuration;
    this._channelPos = new List(this._channels.length);
  }
  
  void _advanceChannel(int index) {
    // Index is not outside of range
    if (index < this._channels.length) {
      // Current animation
      // _channelPos hasn't been reset
      if (this._channelPos[index] != -1) {
        final Animation currentAnimation = this._channels[index][this._channelPos[index]];
      
        // Animation is now complete
        if (currentAnimation._playing) {
          currentAnimation._playing = false;
          currentAnimation._animationCompleteController.add(currentAnimation);
          
          if (currentAnimation._options._destroyOnComplete) {
            currentAnimation.destroy();
          }
        }
      }
      
      // Next animation
      final int nextIndex = ++this._channelPos[index];
      if (nextIndex < this._channels[index].length) {
        // Start animation
        final Animation nextAnimation = this._channels[index][nextIndex];
        nextAnimation._position = 0;
        nextAnimation._animationStartController.add(nextAnimation);
        nextAnimation._playing = true;
      }
    }
  }

  void _complete(Animation _) {
    if (this._options._loop) {
      this.start();
      return;
    }
    
    this._playing = false;
    this._timelineCompleteController.add(this);

    if (this._options._destroyOnComplete) {
      this.destroy();
    }
  }
  
  void _processAction(Animation _) {
    final int msFromStart = new DateTime.now().millisecondsSinceEpoch - _timelineAnimation._timeAnchor;
    
    int index = 0;
    for (List<Animation> animations in this._channels) {
      // Get the current animation for each channel
      final int currentIndex = this._channelPos[index];
      if (currentIndex >= this._channels[index].length) {
        index++;
        continue;
      }
      
      final Animation animation = animations[currentIndex];
      animation._position = (msFromStart - animation._timelineOffset) / 1000;
      
      if (animation._position > animation._duration) {
        animation._position = animation._duration;
      }
      
      animation._progress = animation._options._tween(animation._position / animation._duration);
      animation._animationActionController.add(animation);
      
      // duration == position -> we reached the end
      if (animation._duration - animation._position < 0.00000000000001) {
        this._advanceChannel(index);
      }
      
      index++;
    }
  }
  
  void start() {
    this._timelineStartController.add(this);
    this._playing = true;
    
    int index = 0;
    for (List<Animation> animations in this._channels) {
      // Reset _channelPos
      this._channelPos[index] = -1;
      // Move to the next animation
      this._advanceChannel(index);
      
      // Reset each animations
      //for (Animation animation in animations) {
      //  animation.goTo(0);
      //}
      
      index++;
    }
    
    this._timelineAnimation.start();
  }

  void stop() {
    if (this._playing) {
      this._timelineStopController.add(this);
      this._playing = false;
      
      int index = 0;
      for (List<Animation> animations in this._channels) {
        if(this._channelPos[index] >= animations.length) {continue;}
        // Get the current animation for each channel
        final Animation animation = animations[this._channelPos[index]];
        
        if (animation._playing) {
          animation._animationStopController.add(animation);
          animation._playing = false;
        }
        
        index++;
      }
      
      this._timelineAnimation.stop();
    }
  }
 
  void destroy() {
    // stop the animation in case it's still playing
    this.stop();
    
    this._timelineAnimation.destroy();
    
    for (List<Animation> animations in this._channels) {
      for (Animation animation in animations) {
        animation.destroy();
      }
    }
  }
  
  void resume() {
    if (!this._playing) {
      _timelineResumeController.add(this);
      this._playing = true;

      int index = 0;
      for (List<Animation> animations in this._channels) {
        if(this._channelPos[index] >= animations.length) {continue;}
        // Get the current animation for each channel
        final Animation animation = animations[this._channelPos[index]];
        
        if (!animation._playing) {
          animation._animationResumeController.add(animation);
          animation._playing = true;
        }
        
        index++;
      }

      this._timelineAnimation.resume();
    }
  }
  
  void _addListenersToTimeline() {
    if (this._options._onStart != null) {
      _timelineStartController.stream.listen(this._options._onStart);
    }
    
    if (this._options._onStop != null) {
      _timelineStopController.stream.listen(this._options._onStop);
    }
    
    if (this._options._onComplete != null) {
      _timelineCompleteController.stream.listen(this._options._onComplete);
    }
    
    if (this._options._onResume != null) {
      _timelineResumeController.stream.listen(this._options._onResume);
    }
  }
  
  void _addListenersToAnimation() {
    this._timelineAnimation = new Animation.duration(this._duration);
    this._timelineAnimation._animationActionController.stream.listen(_processAction);
    this._timelineAnimation._animationCompleteController.stream.listen(_complete);
  }
}

class SlideOptions {
  Tween _tween;
  TimelineAction _onStart;
  TimelineAction _onComplete;
  
  SlideOptions({Tween tween, TimelineAction onStart, TimelineAction onComplete}) {
    if (tween == null) {
      this._tween = easeBoth();
    } else {
      this._tween = tween;
    }
    
    this._onStart = onStart;
    this._onComplete = onComplete;
  }
}

class FadeOptions extends SlideOptions {
  FadeOptions({Tween tween, TimelineAction onStart, TimelineAction onComplete}):
    super(tween:tween, onStart:onStart, onComplete:onComplete);
}

Timeline _slideElement(final Element element, num duration, final String action, SlideOptions options) {
  if (options == null) {
    options = new SlideOptions();
  }
  
  TimelineAction onComplete;
  
  int fromHeight = height(element);
  int toHeight;
  
  element.style.overflow = 'hidden'; // Without this, the content of the element won't disappear
  
  // TODO: use data-toggle="opened|closed"
  if ('up' == action || 'toggle' == action && (fromHeight > 0 || element.style.display == 'block')) {
    toHeight = 0;
    
    onComplete = (_) {
      element.style.display = 'none';
      element.style.height = '';
    };
  } else if ('down' == action || 'toggle' == action && (fromHeight <= 0 || element.style.display == 'none')) {
    element.style.display = 'block';
    element.style.height = '';

    toHeight = height(element);
    
    element.style.height = '${fromHeight}px';
    
    onComplete = (_) {
      element.style.display = 'block';
      element.style.height = '';
    };
  }
  
  if (duration == null) {
    final num distance = toHeight - fromHeight;
    duration = 0.3 + (distance / 5000);
  }
  
  final Animation animation = animate(element, duration, 
                            {'height': {'from': '${fromHeight}px', 'to': '${toHeight}px'}},
                                      new AnimationOptions(tween:options._tween));
  final Timeline timeline = new Timeline([[animation]], 
                                         new TimelineOptions(destroyOnComplete:true,
                                         onStart:options._onStart, onComplete:options._onComplete));
  timeline.onComplete(onComplete);
  timeline.start();
  return timeline;  
}

Timeline _fadeTo(final Element element, final double opacity, final num duration, FadeOptions options) {
  if (options == null) {
    options = new FadeOptions();
  }
  
  final Animation animation = animate(element, duration, {'opacity':opacity},
                                      new AnimationOptions(tween:options._tween));
  final Timeline timeline = new Timeline([[animation]], 
      new TimelineOptions(destroyOnComplete:true,
          onStart:options._onStart, onComplete:options._onComplete));
  timeline.start();
  return timeline;
}