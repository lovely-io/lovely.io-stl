#
# An abstract class for bidirectional visual effects
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Fx.Twin extends Fx.Style

  #
  # Hidding the element after the effect
  #
  # @return {Fx.Twin} this
  #
  finish: ->
    if @direction is 'out'
      # calling 'prototype' to prevent circular calls from subclasses
      Element.prototype.hide.call(@element)

    super


# protected

  #
  # Picking up the direction
  #
  setDirection: (direction)->
    if !direction or direction is 'toggle'
      direction = if @element.visible() then 'out' else 'in'

    @direction = direction

    return;

