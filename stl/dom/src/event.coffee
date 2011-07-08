#
# The dom-events basic dom-wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Event extends Wrapper
  type:          null

  which:         null
  keyCode:       null

  target:        null
  currentTarget: null
  relatedTarget: null

  pageX:         null
  pageY:         null

  altKey:        false
  ctrlKey:       false
  metaKey:       false
  shiftKey:      false

  stopped:       false


  #
  # Basic constructor
  #
  # @param {HTMLEvent|String} raw dom event or an event name
  # @param {Object} options for a custom event
  # @return {Event} this
  #
  constructor: (event, options) ->
    if typeof(event) is 'string'
      event = ext({type: event}, options)
      @stopped = event.bubbles is false

      if options isnt null
        ext(this, options)

    @_             = event
    @type          = event.type

    @which         = event.which
    @keyCode       = event.keyCode

    @altKey        = event.altKey
    @ctrlKey       = event.ctrlKey
    @metaKey       = event.metaKey
    @shiftKey      = event.shiftKey

    @pageX         = event.pageX
    @pageY         = event.pageY

    @target        = wrap(event.target)
    @target        = wrap(event.target.parentNode) if event.target and event.target.nodeType is 3

    @currentTarget = wrap(event.currentTarget)
    @relatedTarget = wrap(event.relatedTarget)

    return # nothing

  #
  # Stops the event propagation through the dom-tree
  #
  # @return {Event} this
  #
  stopPropagation: ->
    @_.stopPropagation() if @_.stopPropagation
    @stopped = true

    return @

  #
  # Prevents the browser from default event handling
  #
  # @return {Event} this
  #
  preventDefault: ->
    @_.preventDefault() if @_.preventDefault
    return @

  #
  # a shortcut for `event.stopPropagation().preventDefault()`
  #
  # @return {Event} this
  #
  stop: ->
    @stopPropagation().preventDefault()

  #
  # Returns a standard {x:NNN, y:NNN} position for the event
  #
  # @return {Object} x:NNN, y:NNN
  #
  position: ->
    x: @pageX, y: @pageY

  #
  # Returns event's offset relatively to the target element
  #
  # @return {Object} x:NNN, y:NNN
  #
  offset: ->
    if @target instanceof Element
      element_position = @target.position()

      return {
        x: this.pageX - element_position.x
        y: this.pageY - element_position.y
      }

    # triggered outside browser window (at toolbar etc.)
    return null

  #
  # Finds a matching element in the chain between
  # the target element and the current target
  #
  # @param {String} css-rule
  # @return {Element} mataching element or `null` if nothing found
  #
  find: (css_rule)->
    if @target instanceof Wrapper and @currentTarget instanceof Wrapper
      target = @target._
      search = @currentTarget.find(css_rule, true)

      while target isnt null
        for element in search
          if element is target
            return wrap(target)

        target = target.parentNode

    return null