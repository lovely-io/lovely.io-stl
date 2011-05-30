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

  show: (fx, options)->

  hide: (fx, options)->

  toggle: (fx, options)->

#  remove: (fx, options)->
#    this.$super()


  fade: (how, options)->

  slide: (how, options)->

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
