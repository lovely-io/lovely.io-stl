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

    return @