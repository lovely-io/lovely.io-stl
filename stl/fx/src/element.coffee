#
# The DOM Element extensions for a quick fx calls
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include

  animate: (style, options)->
    new Fx.Style(@, options).start(style)
    return @

  stopFx: ->

  show: (fx, options)->

  hide: (fx, options)->

  toggle: (fx, options)->

#  remove: (fx, options)->
#    this.$super()

  highlight: (start_color, end_color, options)->

  fade: (how, options)->

  slide: (how, options)->

  scroll: (position, options)->
    if position
      new Fx.Scroll(@, options).start(position)
    else
      this.$super()
    return @
