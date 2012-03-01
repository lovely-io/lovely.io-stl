#
# A generic Icon class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Icon extends Element
  #
  # Basic constructor
  #
  # @param {Object} options
  # @return {Icon} self
  #
  constructor: (options)->
    super('i', merge_options(options, {class: 'lui-icon'}))