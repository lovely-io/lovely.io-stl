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

    if items[index]
      console.log("Sliding to #{index}")
      @currentIndex = index

    @prev_button[if @hasPrevious() then 'removeClass' else 'addClass']('lui-disabled')
    @next_button[if @hasNext()     then 'removeClass' else 'addClass']('lui-disabled')

    return @