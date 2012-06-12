#
# A generic Icon class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Icon extends Element
  #
  # Basic constructor
  #
  # @param {Object|String} options or icon name
  # @return {Icon} self
  #
  constructor: (options)->
    options or= {}
    options   = {name: options} if typeof(options) is 'string'
    options['class'] = 'lui-icon-' + options.name if options.name

    delete(options.name)

    super('i', options)

    @on 'mousedown', (event)-> event.preventDefault()