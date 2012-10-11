#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Slideshow extends Element
  include: UI.Options
  extend:
    Options:
      fxDuration: 'normal'
      showButtons: true
      showPager:   true
      autoplay:    false
      delay:       4000
      loop:        true

  currentIndex: null

  #
  # Basic constructor
  #
  # @param {Element} original element
  # @param {Object} options
  # @return {Slideshow} this
  #
  constructor: (element, options)->
    element = Element.resolve(element)._

    @$super(element, @setOptions(options, 'slideshow', element))

    @controls = new Controls(@).insertTo(@)
    @engine   = new Engine(@)

    @on
      mouseenter: =>
        @__hovering = !!@_timer; @pause()
      mouseleave: =>
        @play() if @__hovering
        @__hovering = false

    @slideTo(0)
    @play() if @options.autoplay

    return @

  #
  # Returns the list of items
  #
  # @return {dom.NodeList} items
  #
  items: ->
    @children().reject (item)=> item is @controls

  #
  # Checks whether there is a previous item on the list
  #
  # @return {Boolean} check result
  #
  hasPrevious: ->
    @currentIndex > 0

  #
  # Checks if there is a next item on the list
  #
  # @return {Boolean} check result
  #
  hasNext: ->
    @currentIndex < (@items().length - 1)

  #
  # Shows previous item on the list
  #
  # @return {Slideshow} self
  #
  previous: ->
    @slideTo(@currentIndex - 1)

  #
  # Shows the next item on the list
  #
  # @return {Slideshow} self
  #
  next: ->
    @slideTo(@currentIndex + 1)


  #
  # Slides to the item with given _integer_ index
  #
  # @param {Numeric} item index
  # @return {Slideshow} this
  #
  slideTo: (index)->
    #return if @__sliding; @__sliding = true

    items = @items()

    #if index isnt @currentIndex && @currentIndex isnt null && items[index] && @currentItem
    #  @_slide(index, items[index], @currentItem)
    #else
    #  @__sliding = false

    for item, i in @items()
      if i is index
        item._.className = 'lui-slideshow-current'
        @currentIndex    = index
        @currentItem     = item
      else if i is index - 1
        item._.className = 'lui-slideshow-previous'
      else if i is index + 1
        item._.className = 'lui-slideshow-next'
      else
        item._.className = ''

    @controls.updateStatus()

    return @

  #
  # Starts auto-play mode
  #
  # @return {Slideshow} this
  #
  play: ->
    @_timer or= window.setInterval =>
      if @hasNext()
        @next()
      else if @options.loop
        @slideTo(0)
    , @options.delay

    return @

  #
  # Pauses auto-play mode
  #
  # @return {Slideshow} this
  #
  pause: ->
    if @_timer
      global.clearInterval(@_timer)
      delete(@_timer)

    return @

