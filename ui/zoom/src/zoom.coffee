#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Zoom extends Modal
  include: Options
  extend:
    Options: # default options
      nolock:     true
      fxDuration: 'normal'

    current: null

  #
  # Default constructor
  #
  # @param {Object} options
  # @return {Zoom} self
  #
  constructor: (options)->
    @$super(options).addClass('lui-zoom')

    @locker = new Locker()
    @icon   = new Element('i', title: 'Close')
    @image  = new Element('img')
    @dialog = @first('.lui-inner').append(@image, @icon)

    @icon.on('click', => @hide())

    Element.prototype.insert.call(@, @locker)

  #
  # Downloads and shows the image from the link
  #
  # @param {Element} link
  # @return {Zoom} self
  #
  show: (link)->
    @setOptions(link.data('zoom')).addClass('lui-modal-nolock').addClass('lui-zoom-loading')

    @limit_size($(window).size()).dialog.style('display: none')

    super() # needs to be done _before_ the @locker resize calls

    if @thumb = link.first('img')
      @locker.show().position(@thumb.position()).size(@thumb.size())

    @image = @image.clone().insertTo(@image, 'instead').attr('src', null)
    @image.on('load', =>@loaded()).attr('src', link.attr('href'))

    return Zoom.current = @

  #
  # Making it to emit the 'hide' event and completely
  # remove the whole widget out of the document
  #
  # @return {Zoom} self
  #
  hide: ->
    Zoom.current = null
    @emit('hide').remove()

  #
  # Sets the size limits for the image
  #
  # @param {Object} x: N, y: N size
  # @return {Zoom} this
  #
  limit_size: (size)->
    size =
      maxWidth:  size.x - 20 + 'px'
      maxHeight: size.y -  5 + 'px'

    @image.style  size
    @dialog.style size

    return @

# private

  #
  # Handles the image-load events
  #
  loaded: ->
    @removeClass('lui-zoom-loading').emit 'load'

    @dialog.style('display: inline-block; opacity: 0')

    @[if @options.nolock is true then 'addClass' else 'removeClass']('lui-modal-nolock')

    if @thumb && @options.fxDuration
      @zoom()
    else
      @dialog.style(opacity: 1)
      @emit 'show'

    @locker.hide()

  #
  # Makes the smooth zoom visual effect
  #
  zoom: ()->
    start_pos  = @thumb.position()
    start_size = @thumb.size()

    end_size   = @dialog.size()
    end_pos    = @dialog.position()

    @dialog.addClass('lui-zoom-resizing').size(start_size).position(start_pos)

    pos_diff = @dialog.style('top,left')
    pos_diff = x: parseInt(pos_diff.left), y: parseInt(pos_diff.top)

    @dialog.style(opacity: 1).animate({
      top:     pos_diff.y + (end_pos.y - start_pos.y) + 'px'
      left:    pos_diff.x + (end_pos.x - start_pos.x) + 'px'
      width:   end_size.x + 'px'
      height:  end_size.y + 'px'
    }, duration: @options.fxDuration, finish: =>
      @dialog.removeClass('lui-zoom-resizing').style(top: '', left: '', width: '', height: '')
      @emit 'show'
    )
