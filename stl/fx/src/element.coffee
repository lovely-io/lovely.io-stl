#
# The DOM Element extensions for a quick fx calls
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include

  #
  # Starts the Fx.Style on this element
  #
  # @param {Object} end styles
  # @param {Object} fx-options
  # @return {Element} this
  #
  animate: (style, options)->
    new Fx.Style(@, options).start(style)
    return @

  #
  # Stops all ongoing effects on this element
  #
  # @return {Element} this
  #
  stopFx: ->
    Fx_cancel_all(@)
    return @

  #
  # Makes the element to appear with given fx
  #
  # @param {String} optional fx name
  # @param {Object} fx options
  # @return {Element} this
  #
  show: (fx, options)->
    call_with_fx(@, fx, options, @$super, 'show')

  #
  # Hides the element with given Fx
  #
  # @param {String} optional fx name
  # @param {Object} fx options
  # @return {Element} this
  #
  hide: (fx, options)->
    call_with_fx(@, fx, options, @$super, 'hide')

  #
  # Toggles the element style optionally with the Fx
  #
  # @param {String} optional fx name
  # @param {Object} fx options
  # @return {Element} this
  #
  toggle: (fx, options)->
    call_with_fx(@, fx, options, @$super, 'toggle')

  #
  # Removes the element, optionally with the Fx
  #
  # @param {String} optional fx name
  # @param {Object} fx options
  # @return {Element} this
  #
  remove: (fx, options)->
    call_with_fx(@, fx, options, @$super, 'remove')

  #
  # Runs the Fx.Fade effect on the element
  #
  # @param {String} 'in', 'out' or 'toggle' (default)
  # @param {Object} fx options
  # @return {Element} this
  #
  fade: (direction, options)->
    new Fx.Fade(@, options).start(direction)
    return @

  #
  # Runs the Fx.Slide effect on the element
  #
  # @param {String} 'in', 'out' or 'toggle' (default)
  # @param {Object} fx options
  # @return {Element} this
  #
  slide: (direction, options)->
    new Fx.Slide(@, options).start(direction)
    return @

  #
  # Runs the Fx.Highlight on the element
  #
  # @param {String} start color
  # @param {String} end color
  # @param {Object} options
  # @return {Element} this
  #
  highlight: (start_color, end_color, options)->
    new Fx.Highlight(@, options).start(start_color, end_color)
    return @

  #
  # Calls a smooth scroll on the ellement when asked
  #
  # @param {Object} scrolling position
  # @param {Object} fx-options
  # @return {Element} this
  #
  scroll: (position, options)->
    if isObject(options)
      new Fx.Scroll(@, options).start(position)
    else
      super(position, options)
    return @


# private

call_with_fx = (element, fx, options, original, method)->
  if !(method is 'show' and element.visible()) and !(method is 'hide' and element.hidden())
    if typeof(fx) is 'string'
      fx = fx[0].toUpperCase() + fx.slice(1)
      fx = new Fx[fx](element, options)
      fx.on('finish', -> element.remove()) if method is 'remove'
      fx.start()
    else
      original.call(element)

  return element

