#
# Element's dimensions handling methods
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include
  #
  # Element's size manipulation method. Handles both
  # setting and getting
  #
  # USAGE:
  #     element.size()             // -> x: NNN, y: NNN
  #     element.size(x:NNN, y:NNN) // -> element self
  #     element.size(x:NNN)        // -> element self
  #
  # NOTE: this method will adjust the element size
  #       accordingly to provide the given size regardless
  #       to the paddings and internal element margins
  #
  # @param {Object} size x:NNN, y:NNN in case of setting
  # @return {Element|Object} this element or it's size
  #
  size: (size) ->
    if size is undefined
      return x: this._.offsetWidth, y: this._.offsetHeight
    else
      style = this._.style

      if 'x' of size
        style.width = size.x + 'px'
        style.width = 2 * size.x + this._.offsetWidth + 'px'

      if 'y' of size
        style.height = size.y + 'px'
        style.height = 2 * size.y + this._.offsetHeight + 'px'

      return this

  #
  # Handles the element scrolling position
  #
  # USAGE:
  #     element.scrolls()             // -> x: NNN, y: NNN
  #     element.scrolls(x:NNN, y:NNN) // -> element self
  #     element.scrolls(x:NNN)        // -> element self
  #
  # @param {Object} size x:NNN, y:NNN in case of setting
  # @return {Element|Object} this element or the scrolling positions
  #
  scrolls: (scrolls) ->
    if scrolls is undefined
      return x: this._.scrollLeft, y: this._.scrollTop
    else
      this._.scrollLeft = scrolls.x if 'x' of scrolls
      this._.scrollTop  = scrolls.y if 'y' of scrolls
      return this

  #
  # Handles the element's absolute position
  #
  # USAGE:
  #     element.position()             // -> x: NNN, y:NNN
  #     element.position(x:NNN, y:NNN) // -> element self
  #     element.position(x:NNN)        // -> element self
  #
  # @param {Object} absolute position x:NNN, y:NNN
  # @return {Element|Object} this element of it's absolute position
  #
  position: (position) ->
    if position is undefined
      rect    = this._.getBoundingClientRect()
      html    = this.document()._.documentElement
      scrolls = this.window().scrolls()

      return {
        x: rect.left + scrolls.x - html.clientLeft
        y: rect.top  + scrolls.y - html.clientTop }

    else
      # TODO: implement me
      return this

  #
  # Checks if current element overlaps with the target position
  #
  # @param {Object} x:NNN, y:NNN position
  # @return {Boolean} check result
  #
  overlaps: (target) ->
    pos  = this.position()
    size = this.size()

    target.x >= pos.x and target.x <= (pos.x + size.x) and
    target.y >= pos.y and target.y <= (pos.y + size.y)

  #
  # Returns the element index among it's siblings
  #
  # NOTE: this method skips the text nodes!
  #
  # @return {Number} index
  #
  index: ->
    node  = this._.previousSibling
    index = 0

    while node
      index++ if node.nodeType is 1
      node = node.previousSibling

    index
