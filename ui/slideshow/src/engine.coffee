#
# This file contains the actual sliding effect engine
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Engine

  #
  # Constructor. Hooks up the events and stuff
  #
  # @param {Slideshow} reference
  # @return {Engine} this
  #
  constructor: (slideshow)->
    @slideshow = slideshow

    slideshow.on
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
          slideshow.previous()
          @__touchstart = x_position
        else if (@__touchstart - x_position) > threshold
          @__sliding = true
          slideshow.next()
          @__touchstart = x_position

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
