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

  currentIndex: null

  #
  # Basic constructor
  #
  # @param {Element} original element
  # @param {Object} options
  # @return {Slideshow} this
  #
  constructor: (element, options)->
    super(element._)

    @setOptions(options)

    @append new Element('div', {
      class: 'lui-slideshow-controls'
    }).append(
      @prev_button = new Icon(class: 'lui-icon-previous2').on('click', => @previous()),
      @next_button = new Icon(class: 'lui-icon-next2').on('click', => @next())
    )

    @slideTo(0)

  #
  # Returns the list of items
  #
  # @return {dom.NodeList} items
  #
  items: ->
    @children().reject (item)->
      item._.tagName isnt 'LI'

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

    return @


# protected

  # makes the actual sliding effect
  _slide: (index, item, cur_item)->
    return if @__sliding; @__sliding = true

    end_size = @_end_size(item)      # getting the end size
    old_size = @size(@size()).size() # freezing up the size

    # calculating the left-position for the slide
    end_left = if old_size.x > end_size.x then old_size.x else end_size.x
    end_left *= -1 if @currentIndex > index

    # presetting initial styles
    @addClass('lui-slideshow-resizing')
    cur_item.style(position: 'absolute', left: '0px')
    item.style(display: 'block', position: 'absolute', left: end_left + 'px')

    # visualizing the slide
    item.size(end_size).animate {left: '0px'},
      duration: @options.fxDuration,
      finish: -> item.style(position: 'relative')

    cur_item.animate {left: (- end_left) + 'px'},
      duration: @options.fxDuration,
      finish: -> cur_item.style(display: 'none')

    # animating the size change
    @animate {
      width:  end_size.x + 'px'
      height: end_size.y + 'px'
    }, duration: @options.fxDuration, finish: =>
      @removeClass('lui-slideshow-resizing')
      @__sliding = false


  # calculates the end size of the whole block
  _end_size: (item)->
    @__clone or= @clone().style(position: 'absolute', left: '-99999em')
    @__clone.update(item.clone().style(display: 'block', position: 'relative'))
    @__clone.insertTo(@, 'after')

    @__clone.size()



