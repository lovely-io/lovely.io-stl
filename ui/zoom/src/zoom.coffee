#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Zoom extends Element
  extend:
    # default options
    Options: {
      fxDuration: 'normal'
    }

  #
  # Default constructor
  #
  # @param {Object} options
  # @return {Zoom} self
  #
  constructor: (options)->
    @locker = new Locker()
    @dialog = new Element('div', class: 'dialog')
    @image  = new Element('img', on: {load: =>@zoom()})
    @icon   = new Element('i', title: 'Close')

    super('div', class: 'lui-zoom lui-locker')

    @append(new Element('div', class: 'lui-aligner'))
    @append(@dialog.append(@image, @icon), @locker)
    @on 'click', (event)->
      if event.target is @ or event.target is @icon
        @remove()

  #
  # Downloads and shows the image from the link
  #
  # @param {Element} link
  # @return {Zoom} self
  #
  show: (link)->
    hide_all_zooms()

    @style(left: '-99999em')
    @insertTo(document.body)

    thmb = link.first('img')

    @locker.show().position(thmb.position()).size(thmb.size())
    @image.attr('src', link.attr('href'))

    return @

# private

  #
  # Makes the actual zoom
  #
  zoom: ()->
    @style(left: '0px')

