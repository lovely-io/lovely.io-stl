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

    @on
      mouseenter: =>
        @__hovering = !!@_timer; @pause()
      mouseleave: =>
        @play() if @__hovering
        @__hovering = false
      touchstart: (event)=>
        @__sliding    = false
        @__touchstart = event.position().x
        event.preventDefault()
      touchmove: (event)=>
        return if @__sliding

        x_position = event.position().x
        threshold  = 20

        if (x_position - @__touchstart) > threshold
          @__sliding = true
          @previous()
          @__touchstart = x_position
        else if (@__touchstart - x_position) > threshold
          @__sliding = true
          @next()
          @__touchstart = x_position

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


    @controls.prev_button[if @hasPrevious() then 'removeClass' else 'addClass']('lui-disabled')
    @controls.next_button[if @hasNext()     then 'removeClass' else 'addClass']('lui-disabled')

    @controls._rebuild_pager(@)

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


# protected

  # makes the actual sliding effect
  _slide: (index, item, cur_item)->

    item.radioClass('lui-slideshow-current')

    return

    box_size = @_end_size(item)
    old_size = cur_item.size()
    end_size = box_size.item_size
    box_size = box_size.list_size

    # calculating the left-position for the slide
    end_left = if old_size.x > end_size.x then old_size.x else end_size.x
    end_left *= -1 if @currentIndex > index

    # presetting initial styles
    @addClass('lui-slideshow-resizing').size(@size())
    cur_item.size(old_size).style(position: 'absolute', left: '0px')
    item.style(display: 'block', position: 'absolute', left: end_left + 'px')

    # visualizing the slide
    item.size(end_size).animate {left: '0px'},
      duration: @options.fxDuration,
      finish: -> item.style(position: 'relative', width: '', height: '')

    cur_item.animate {left: (- end_left) + 'px'},
      duration: @options.fxDuration,
      finish: -> cur_item.style(display: 'none', width: '', height: '')

    # animating the size change
    @animate box_size, duration: @options.fxDuration, finish: =>
      @removeClass('lui-slideshow-resizing')
      global.setTimeout((=>@__sliding = false), 50)


  # calculates the end size of the whole block
  _end_size: (item)->
    @__clone or= @clone().style(visibility: 'hidden').insertTo(@, 'after')
    @__clone.style(display: '')

    item = item.clone().style(display: 'block', position: 'relative')

    result =
      list_size: @__clone.update(item).style('width,height')
      item_size: item.size()

    @__clone.style(display: 'none')

    return result
