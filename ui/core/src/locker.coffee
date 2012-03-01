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
    super('div', merge_options(options, class: 'lui-locker'))
    @insert('<div class="lui-aligner"></div>')
    @insert(@spinner = new Spinner(size: 5, class: 'lui-inner'))
