#
# This file contains the controls block of the slideshow
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Controls extends Element

  #
  # Constructor, builds the control elements
  #
  # @param {Slideshow} reference
  # @return {Controls} this
  #
  constructor: (slideshow)->
    super 'div', class: 'lui-slideshow-controls'

    @prev_button = new Icon('circle-arrow-left', on: click: -> slideshow.previous())
    @next_button = new Icon('circle-arrow-right', on: click: -> slideshow.next())
    @pager       = new Element('div', class: 'lui-slideshow-pager')

    @append(@prev_button, @next_button, @pager)

    if typeof(window.ontouchstart) isnt 'undefined' or !slideshow.options.showButtons
      slideshow.addClass('lui-slideshow-no-buttons')

    @pager.delegate('a', click: (e)-> e.stop(); slideshow.slideTo(e.target.data('index')))
    slideshow.addClass('lui-slideshow-no-pager') unless slideshow.options.showPager

    return @


  # rebuilds the pagination element
  _rebuild_pager: (slideshow)->
    html = for item, index in slideshow.items()
      attr = if index is slideshow.currentIndex then ' class="lui-slideshow-pager-current"' else ''
      """<a href="" data-index="#{index}"#{attr}>&bull;</a>"""

    @pager.html(html.join(''))
