#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Slideshow extends Element
  include: Options
  extend:
    Options:
      fxDuration: 'normal'

  #
  # Basic constructor
  #
  # @param {Element} original element
  # @param {Object} options
  # @return {Slideshow} this
  #
  constructor: (element, options)->
    super(element._)

    @setOptions(options)
    @append new Element('div', {
      class: 'lui-slideshow-controls'
    }).append(
      new Icon(class: 'lui-icon-previous2').on('click', => @previous()),
      new Icon(class: 'lui-icon-next2').on('click', => @next())
    )

    return @

  #
  # Shows previous item on the list
  #
  # @return {Slideshow} self
  #
  previous: ->
    console.log("Shows the previous item on the list")

  #
  # Shows the next item on the list
  #
  # @return {Slideshow} self
  #
  next: ->
    console.log("Shows the next item on the list")