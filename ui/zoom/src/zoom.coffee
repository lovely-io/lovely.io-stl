#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Zoom extends Element
  include: Options
  extend:
    Options: # default options
      lockScreen: false

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

    @setOptions(link.data('zoom'))
    @removeClass('lock-screen')

    @dialog.style(opacity: 0)
    @insertTo(document.body)

    if @thmb = link.first('img')
      @locker.show().position(@thmb.position()).size(@thmb.size())

    @image.attr('src', link.attr('href'))

    return @

# private

  #
  # Makes the actual zoom
  #
  zoom: ()->
    @style(opacity: 0)
    @locker.style(display: 'none')
    @dialog.style(opacity: 1)

    @[if @options.lockScreen then 'addClass' else 'removeClass']('lock-screen')

    if @thmb
      start_pos  = @thmb.position()
      start_size = @thmb.size()

      end_size   = @dialog.size()
      end_pos    = @dialog.position()

      @dialog.style(position: 'absolute').size(start_size).position(start_pos)
      @image.style width: '100%', height: '100%'

      pos_diff = @dialog.style('top,left')
      pos_diff = x: parseInt(pos_diff.left), y: parseInt(pos_diff.top)

      #@dialog.style(opacity: 1)
      @dialog.animate({
        top:     pos_diff.y + (end_pos.y - start_pos.y) + 'px'
        left:    pos_diff.x + (end_pos.x - start_pos.x) + 'px'
        width:   end_size.x + 'px'
        height:  end_size.y + 'px'
      }, finish: =>
        console.log('fuck')
      )

    @animate opacity: 1




