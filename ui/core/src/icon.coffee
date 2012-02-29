#
# A generic Icon class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Icon extends Input
  #
  # Basic constructor
  #
  # @param {Object} options
  # @return {Icon} self
  #
  constructor: (options)->
    options = merge_options(options, {
      type: 'button', class: 'lui-icon'
    })

    super 'button', options