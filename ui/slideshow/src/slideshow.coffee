#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Slideshow extends Element
  include: Options
  extend:
    Options:
      fxDuration: 'normal'
      autoplay:   false
      delay:      4000
      loop:       true

  currentIndex: null

  #
  # Basic constructor
  #
  # @param {Element} original element
  # @param {Object} options
  # @return {Slideshow} this
  #
  constructor: (element, options)->
    @$super(element._).setOptions(@data('slideshow'))

    @controls = new Element('div', {class: 'lui-slideshow-controls'}).append(
      @prev_button = new Icon(class: 'lui-icon-previous2').on('click', => @previous()),
      @next_button = new Icon(class: 'lui-icon-next2').on('click', => @next()),
      @pager       = new Element('div', class: 'lui-slideshow-pager'))

    if typeof(window.ontouchstart) isnt 'undefined'
      @prev_button.remove(); @next_button.remove();

    @pager.delegate('a', click: (e)=> e.stop(); @slideTo(e.target.data('index')))

    @on
      mouseenter: => @__hovering = true
      mouseleave: => @__hovering = false
      touchstart: (event)=>
        @__touchstart = event.position().x
      touchmove: (event)=>
        return if @__sliding
        x_position = event.position().x
        threshold  = 20

        if (x_position - @__touchstart) > threshold
          @previous()
          @__touchstart = x_position
        else if (@__touchstart - x_position) > threshold
          @next()
          @__touchstart = x_position


    @append(@controls).slideTo(0)
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
    items = @items()

    if index isnt @currentIndex && @currentIndex isnt null && items[index] && @currentItem
      @_slide(index, items[index], @currentItem)

    @currentIndex = index
    @currentItem  = items[index]

    @prev_button[if @hasPrevious() then 'removeClass' else 'addClass']('lui-disabled')
    @next_button[if @hasNext()     then 'removeClass' else 'addClass']('lui-disabled')

    @_rebuild_pager()

  #
  # Starts auto-play mode
  #
  # @return {Slideshow} this
  #
  play: ->
    @_timer or= window.setInterval =>
      unless @__hovering
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
    return if @__sliding; @__sliding = true

    box_size = @_end_size(item)
    old_size = cur_item.size()
    end_size = item.style(display: 'block', position: 'absolute', left: '-9999em').size()

    # calculating the left-position for the slide
    end_left = if old_size.x > end_size.x then old_size.x else end_size.x
    end_left *= -1 if @currentIndex > index

    # presetting initial styles
    @addClass('lui-slideshow-resizing').size(@size())
    cur_item.style(position: 'absolute', left: '0px')
    item.style(left: end_left + 'px')

    # visualizing the slide
    item.size(end_size).animate {left: '0px'},
      duration: @options.fxDuration,
      finish: -> item.style(position: 'relative')

    cur_item.animate {left: (- end_left) + 'px'},
      duration: @options.fxDuration,
      finish: -> cur_item.style(display: 'none')

    # animating the size change
    @animate box_size, duration: @options.fxDuration, finish: =>
      @removeClass('lui-slideshow-resizing')
      global.setTimeout((=>@__sliding = false), 50)


  # calculates the end size of the whole block
  _end_size: (item)->
    @__clone or= @clone().style(position: 'absolute', left: '-99999em').insertTo(@, 'after')
    @__clone.update(item.clone().style(display: 'block', position: 'relative'))

    clone = @__clone.clone().insertTo(@, 'after').size(@__clone.size())
    result = clone.style('width,height')
    clone.remove()

    return result

  # rebuilds the pagination element
  _rebuild_pager: ->
    html = for item, index in @items()
      attr = if index is @currentIndex then ' class="lui-slideshow-pager-current"' else ''
      """<a href="" data-index="#{index}"#{attr}>&bull;</a>"""

    @pager.html(html.join(''))







