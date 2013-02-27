part of pwt_animation;

typedef double Tween(double progress);

/**
 * Returns linear tween.
 * 
 * Will transition values from start to finish with no acceleration or deceleration.
 */
Tween linear() => (double progress) => progress;

/**
 * Creates a tween which starts off slowly and accelerates.   
 * 
 * A higher number means the animation starts off slower and ends quicker.
 * 
 * [strength] How strong the easing is.
 */
Tween easeIn({int strength:2}) {
  if (strength == null) {
    strength = 2;
  }
  
  return (double progress) => pow(1, strength - 1) * pow(progress, strength);
}

/**
 * Creates a tween which starts off fast and decelerates.
 * 
 * A higher number means the animation starts off faster and ends slower
 * 
 * [strength] How strong the easing is.
 */
Tween easeOut({int strength:2}) => _reverse(easeIn(strength:strength));

/**
 * Creates a tween which starts off slowly, accelerates then decelerates after the half way point.
 * 
 * This produces a smooth and natural looking transition.
 * 
 * [strength] A higher number produces a greater difference between start / 
 * end speed and the mid speed.
 */
Tween easeBoth({int strength:2})
  => combine(easeIn(strength:strength), easeOut(strength:strength));

/**
 * Creates a tween which overshoots its end point then returns to its end point.
 * 
 * [amount] How much to overshoot.
 * 
 * The default is 1.70158 which results in a 10% overshoot.
 */
Tween overshootOut({double amount:1.70158}) {
  if (amount == null) {
    amount = 1.70158;
  }
  
  return (double progress) {
    if (progress == 0 || progress == 1) { 
      return progress; 
    } else {
      return ((progress -= 1)* progress * ((amount + 1) * progress + amount) + 1);
    }
  };
}

/**
 * Returns the reverse of [overshootOut()]
 * 
 * [amount] How much to overshoot.
 * 
 * The default is 1.70158 which results in a 10% overshoot.
 */
Tween overshootIn({double amount:1.70158}) {
  return _reverse(overshootOut(amount:amount));
}

/**
 * Returns a combination of [overshootIn()] and [overshootOut()]
 * 
 * [amount] How much to overshoot.
 * 
 * The default is 1.70158 which results in a 10% overshoot.
 */
Tween overshootBoth({double amount:1.70158}) {
  return combine(overshootIn(amount:amount), overshootOut(amount:amount));
}

/**
 * Returns a tween which bounces against the final value 3 times before stopping
 */
Tween bounceOut()
=> (double progress) {
  if (progress < (1 / 2.75)) {
    return 7.5625 * progress * progress;
  } else if (progress < (2 / 2.75)) {
    return (7.5625 * (progress -= (1.5 / 2.75)) * progress + .75);
  } else if (progress < (2.5 / 2.75)) {
    return (7.5625 * (progress -= (2.25 / 2.75)) * progress + .9375);
  } else {
    return (7.5625 * (progress -= (2.625 / 2.75)) * progress + .984375);
  }
};

/**
 * Returns the reverse of [bounceOut()]
 */
Tween bounceIn() => _reverse(bounceOut());

/**
 * Returns a combination of [bounceIn()] and [bounceOut()]
 */
Tween bounceBoth() {
  return combine(bounceIn(), bounceOut());
}

/**
 * Creates a tween which has an elastic movement.
 * 
 * You can tweak the tween using the parameters but you'll probably find the defaults sufficient.
 * 
 * [amplitude=1] How strong the elasticity is.
 * 
 * [period=0.3] The frequency period.
 */
Tween elasticOut({double amplitude:1.0, double period:0.3})
  => (double progress) {
    if (progress == 0 || progress == 1) {
      return progress;
    }
    
    if (period == null) {
      period = 0.3;
    }
    
    var s;
    if (amplitude == null || amplitude < 1) {
      amplitude = 1.0;
      s = period / 4;
    } else {
      s = period / (2 * PI) * asin(1 / amplitude);
    }
    return amplitude * pow(2, -10 * progress) * sin((progress - s) * (2 * PI) / period) + 1;
  };

/**
 * Returns the reverse of [elasticOut()]
 * 
 * [amplitude=1] How strong the elasticity is.
 * 
 * [period=0.3] The frequency period.
 */
Tween elasticIn({double amplitude:1.0, double period:0.3})
  => _reverse(elasticOut(amplitude:amplitude, period:period));
  
/**
 * Returns a combination of [elasticIn()] and [elasticOut()]
 * 
 * [amplitude=1] How strong the elasticity is.
 * 
 * [period=0.45] The frequency period.
 */
Tween elasticBoth({double amplitude:1.0, double period:0.45}) {
  if (period == null) {
    period = 0.45;
  }
  return combine(elasticIn(amplitude:amplitude, period:period), 
                 elasticOut(amplitude:amplitude, period:period));
}

/**
 * Takes a tween function and returns a function which does the reverse
 */
Tween _reverse(Tween tween) 
  => (double progress) 
    => 1 - tween(1 - progress);

/**
 * Create a tween from two tweens.
 * 
 * This can be useful to make custom tweens which, for example,
 * start with an easeIn and end with an overshootOut. To keep
 * the motion natural, you should configure your tweens so the
 * first ends and the same velocity that the second starts.
 * 
 * [tweenIn] Tween to use for the first half.
 * 
 * [tweenOut] Tween to use for the second half.
 */
Tween combine(Tween tweenIn, Tween tweenOut)
  => (double progress) {
    if (progress < 0.5) {
      return tweenIn(progress * 2) / 2;
    } else {
      return tweenOut((progress - 0.5) * 2) / 2 + 0.5;
    }
  };