#
# A generic ui-button class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Button extends Input

  #
  # Basic constructor, can receive some additional HTML options
  #
  # @param {String} caption
  # @param {Object} options
  # @return {Button} self
  #
  constructor: (html, options)->
    options = merge_options(options, {
      type: 'button', html: html, class: 'lui-button'
    })

    super('button', options)