#
# Generic imageless spinner class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Spinner extends Element
  extend:
    DEFAULT_SIZE: 4

  #
  # Default constructor
  #
  # NOTE: this constructor can take additional `size` option
  #       to set how many pieces it should has
  #
  # @param {Object} html-options
  # @return {Spinner} self
  #
  constructor: (options)->
    options = merge_options(options, {class: 'lui-spinner'})
    options.html = build_spinner_divs(options.size)
    delete(options.size)

    super('div', options)
    move_spinner(@)




# builds the spinner
build_spinner_divs = (size)->
  size or= Spinner.DEFAULT_SIZE; i = 1; html = ''
  while i < size
    html += '<div></div>'; i += 1

  html + '<div class="lui-spinner-current"></div>'

move_spinner = (spinner)->
  window.setInterval ->
    dot = spinner.first('.lui-spinner-current')
    (dot.nextSibling() || spinner.first()).radioClass('lui-spinner-current')
  , 300

  return spinner