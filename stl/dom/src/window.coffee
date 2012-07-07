#
# The window dom-wrapper
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
class Window extends Wrapper
  # copying the standard events handling interface from `Element.prototype`
  include: Element_events

  constructor: (window)->
    Wrapper.call(this, window)

  #
  # A self-reference to have a common interface with
  # the rest of the wrappers
  #
  # @return {Window} this
  #
  window: -> this

  #
  # Handles the _inner_ size of a window
  #
  #     :js
  #     $(window).size();             // -> x:NNN, y:NNN size
  #     $(window).size(x:NNN, y:NNN); // sets the inner size
  #     $(window).size(x:NNN);        // sets the horizontal size
  #     $(window).size(y:NNN);        // sets the vertical size
  #     $(window).size(x, y);         // sets the inner size
  #     $(window).size(x, null);      // sets the horizontal size
  #     $(window).size(null, y);      // sets the vertical size
  #
  # @param {Object|Number} size hash or a horizontal size
  # @param {Number} vertical size in case of a two arguments call
  # @return {Object|Window} the inner size or this window reference
  #
  size: (size)->
    if size is undefined
      win = @_; html = win.document.documentElement

      return if win.innerWidth then x: win.innerWidth, y: win.innerHeight
      else x: html.clientWidth, y: html.clientHeight

    else
      size   = dimensions_hash(arguments)
      size.x = @size().x unless 'x' of size
      size.y = @size().y unless 'y' of size

      @_.resizeTo size.x, size.y

      # readjusting for the window toolbars and borders
      @_.resizeTo (2 * size.x - @size().x), (2 * size.y - @size().y)

      return @

  #
  # Reads or sets window scrolling positions
  #
  #     :js
  #     $(window).scrolls();             // -> x:NNN, y:NNN scrolls
  #     $(window).scrolls(x:NNN, y:NNN); // sets the scrolling position
  #     $(window).scrolls(x:NNN);        // sets the horizontal scrolling
  #     $(window).scrolls(y:NNN);        // sets the vertical scrolling
  #     $(window).scrolls(x, y);         // sets the scrolling position
  #     $(window).scrolls(x, null);      // sets the horizontal scrolling
  #     $(window).scrolls(null, y);      // sets the vertical scrolling
  #
  # @param {Object|Number} scrolling position hash or left scrolling position
  # @param {Number} top scrolling position, in case of a two arguments call
  # @return {Object|Window} current scrolling position or this window object
  #
  scrolls: (position)->
    if position is undefined
      win  = @_
      doc  = win.document
      body = doc.body
      html = doc.documentElement

      if win.pageXOffset || win.pageYOffset
        return x: win.pageXOffset, y: win.pageYOffset
      else if body && (body.scrollLeft || body.scrollTop)
        return x: body.scrollLeft, y: body.scrollTop
      else
        return x: html.scrollLeft, y: html.scrollTop

    else # setting the scrolls
      position   = dimensions_hash(arguments)
      position.x = @scrolls().x unless 'x' of position
      position.y = @scrolls().y unless 'y' of position

      @_.scrollTo position.x, position.y

      return @
