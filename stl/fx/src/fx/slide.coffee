#
# The basic slide visual effect
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Fx.Slide extends Fx.Twin
  extend:
    Options: Hash.merge(Fx.Options, {
      direction: 'top'
    })


# protected
  prepare: (direction)->
    @setDirection(direction)

    # calling 'prototype' to prevent circular calls from subclasses
    element = Element.prototype.show.call(@element)
    element_style = element._.style
    old_styles = element.style('overflow,width,height,marginTop,marginLeft')

    restore_styles = ->
      ext(element_style, old_styles)

    @on 'finish,cancel', restore_styles

    element_style.overflow = 'hidden'

    # figuring the actual element styles for it's sizes
    # to avoid problems with paddings and border sizes
    element_size = element.size()
    element.size(element_size)
    element_size =
      x: parseInt(element.style('width'))
      y: parseInt(element.style('height'))

    end_style = fx_slide_prepare_styles(
      element_style,
      element_size,
      @options.direction,
      @direction)

    super end_style


fx_slide_prepare_styles = (element_style, size, direction, how)->
  style       = {}
  margin_left = parseFloat(element_style.marginLeft) || 0
  margin_top  = parseFloat(element_style.marginTop)  || 0
  to_right    = direction is 'right'
  to_bottom   = direction is 'bottom'
  vertical    = direction is 'top' || to_bottom

  if how is 'out'
    style[if vertical then 'height' else 'width'] = '0px'

    if vertical
      element_style.height = size.y + 'px'
    else
      element_style.width = size.y + 'px'

    if to_right
      style.marginLeft = margin_left + size.x+'px'
    else if to_bottom
      style.marginTop = margin_top + size.y +'px'

  else
    if vertical
      style.height = size.y + 'px'
      element_style.height  = '0px'
    else
      style.width = size.x + 'px'
      element_style.width  = '0px'

    if to_right
      style.marginLeft = margin_left + 'px'
      element_style.marginLeft = margin_left + size.x + 'px'
    else if to_bottom
      style.marginTop = margin_top + 'px'
      element_style.marginTop = margin_top + size.y + 'px'

  return style