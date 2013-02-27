part of pwt_animation;

Animation animate(final Element element, final num duration, 
              final Map properties, final AnimationOptions options)
  => new Animation(element, duration, properties, options);

Timeline slideDown(final Element element, [final num duration = 1, final SlideOptions options]) 
  => _slideElement(element, duration, 'down', options);

Timeline slideUp(final Element element, [final num duration = 1, final SlideOptions options])
  => _slideElement(element, duration, 'up', options);

Timeline slideToggle(final Element element, [final num duration = 1, final SlideOptions options])
  => _slideElement(element, duration, 'toggle', options);

Timeline fadeOut(final Element element, [final num duration = 1, final FadeOptions options])
  => _fadeTo(element, 0.0, duration, options);

Timeline fadeIn(final Element element, [final num duration = 1, final FadeOptions options])
  => _fadeTo(element, 1.0, duration, options);

Timeline fadeTo(final Element element, final double opacity, [final num duration = 1, final FadeOptions options])
=> _fadeTo(element, opacity, duration, options);