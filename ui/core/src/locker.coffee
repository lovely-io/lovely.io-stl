#
# A generic locker unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Locker extends Element

  #
  # Basic constructor
  #
  # @param {Object} html options
  # @return {Locker} self
  #
  constructor: (options)->
    options = merge_options(options, class: 'lui-locker')
    spinner_size = options.size || 5
    delete(options.size)
    super('div', options)
    @insert('<div class="lui-aligner"></div>')
    @insert(@spinner = new Spinner(size: spinner_size, class: 'lui-inner'))
