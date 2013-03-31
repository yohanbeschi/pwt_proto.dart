part of pwt_animation;

final AnimationQueue _manager = new AnimationQueue();

class AnimationQueue {
  // Animations queue
  List<Animation> _queue = new List(); 
  // Queue timer
  Timer _timer;
  // Queue processing every 13ms
  Duration _intervalTime = new Duration(milliseconds:13);
  
  /**
   * Adds an [Animation] to the queue.
   */
  void _addToQueue(final Animation animation) {
    _queue.add(animation);
    animation._playing = true;
    animation._timeAnchor = animation._timeAnchor != null 
                            ? animation._timeAnchor 
                            : new DateTime.now().millisecondsSinceEpoch;
    if (_timer == null) {
      this._startTimer();
    }
  }
  
  /**
   * Removes an [Animation] from the queue.
   */
  void _removeFromQueue(Animation animation) {
    if (_queue.contains(animation)) {
      animation._timeAnchor = null;
      animation._playing = false;
      
      _queue.remove(animation);
      
      //stop the queue if there's nothing in it anymore
      if (_queue.length == 0) {
        this._stopTimer();
      }
    }
  }
  
  /**
   * Start processing the queue every [_intervalTime].
   */
  void _startTimer() {
    this._timer = new Timer.periodic(_intervalTime, this._processQueue);
  }
  
  /**
   * Stop processing the queue.
   */
  void _stopTimer() {
    this._timer.cancel();
    this._timer = null;
  }
  
  /**
   * Animate each animation in the queue.
   */
  void _processQueue(final Timer timer) {
    final int now = new DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < this._queue.length; i++) {
      Animation animation = this._queue[i];
      // duration == position -> we reached the end
      if (animation._duration - animation._position < 0.00000000000001) {
        _removeFromQueue(animation);

        animation._animationCompleteController.add(animation);

        if (animation._options._destroyOnComplete) {
          animation.destroy();
        }
        continue;
      }
      
      // Seconds
      if (animation._options._useSeconds) {
        animation._position = (now - animation._timeAnchor) / 1000;
        if (animation._position > animation._duration) {
          animation._position = animation._duration;
        }
      }
      // Frames
      else {
        animation._position++;
      }
      animation._progress = animation._options._tween(animation._position / animation._duration);
      animation._animationActionController.add(animation);
    }
  }
}
