#
# Generic imageless spinner class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Spinner extends Element
  include: Options
  extend:
    Options:
      size:   5
      type:   'cicular'
      rotate: true

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
    @$super 'div', @setOptions(options)
    @addClass 'lui-spinner'
    @html build_spinner_divs(@)




# builds the spinner
build_spinner_divs = (spinner)->
  i = 1; html = ''

  while i < spinner.options.size - 1
    html += '<div></div>'; i += 1

  html += '<div class="lui-spinner-current"></div>'

  window.setInterval ->
    dot = spinner.first('.lui-spinner-current')
    (dot.nextSibling() || spinner.first()).radioClass('lui-spinner-current')
  , 300

  return html