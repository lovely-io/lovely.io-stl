#
# This file contains the controls block of the slideshow
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Controls extends Element

  constructor: (options)->
    super 'div', class: 'lui-slideshow-controls'

    @prev_button = new Icon('circle-arrow-left').on('click', => @previous())
    @next_button = new Icon('circle-arrow-right').on('click', => @next())
    @pager       = new Element('div', class: 'lui-slideshow-pager')

    @append(@prev_button, @next_button, @pager)

    if typeof(window.ontouchstart) isnt 'undefined'
      @prev_button.remove(); @next_button.remove();

    @pager.delegate('a', click: (e)=> e.stop(); @slideTo(e.target.data('index')))
    @pager.remove() unless options.showPager

    return @


  # rebuilds the pagination element
  _rebuild_pager: (slideshow)->
    html = for item, index in slideshow.items()
      attr = if index is slideshow.currentIndex then ' class="lui-slideshow-pager-current"' else ''
      """<a href="" data-index="#{index}"#{attr}>&bull;</a>"""

    @pager.html(html.join(''))
