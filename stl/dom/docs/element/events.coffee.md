This file provides the standard events handling interface.
Basically it uses the {core.Events} mixin
but adoptes it for the dom-events handling

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
Element.include Element_events =
  _listeners: null  # the listeners index
```

Attaching an event listener

See the {core.Events} for the actual API

```coffee-aside
  on: ->
    @_listeners is null && Element_make_listeners(@)
    Lovely.Events.on.apply(@, arguments)
```

Removes an event listener

See the {core.Events} for the actual API

```coffee-aside
  no: ->
    @_listeners is null && Element_make_listeners(@)
    Lovely.Events.no.apply(@, arguments)
```

Checks if an event listener is attached

See the {core.Events} for the actual API

```coffee-aside
  ones: Lovely.Events.ones
```

Fires an event on the element

__NOTE__: the event will propogate through
the dom structure, up to the document!

@param {String} event name
@param {Object} event attributes
@return {Wrapper} this

```coffee-aside
  emit: (event, options) ->
    parent = wrap(this._.parentNode)

    unless event instanceof Event
      event = new Event(event, ext({target: @_}, options))

    # setting up the currentTarget reference
    event.currentTarget = @

    # calling every registered callback with the event
    for hash in @_listeners || []
      if hash.e is event.type
        args = (if hash.n then [] else [event]).concat(hash.a)
        event.stop() if hash.c.apply(@, args) is false


    # manually bypassing the event to the parent element
    parent.emit(event) if !event.stopped && parent

    return @
```

A shortcut for calls-by-name

    :js
    event.on('click', 'stopEvent')

@return {Boolean} false

```coffee-aside
  stopEvent: ->
    return false
```

Makes a smart event listeners registry
that will add/remove event listeners autmoatically
to the real dom-element

```coffee-aside
Element_make_listeners = (instance) ->
  list = []

  # hijacking the Array#push method to attach
  # the actual dom event-listeners
  list.push = (hash) ->
    if hash.e in ['mouseenter', 'mouseleave']
      # MouseIO module handles those events on itsown
      mouseio_activate()
      hash.r = hash.e
      hash.w = ->

    else
      hash.r = hash.e

      # adjusting the real event name for the current browser
      hash.r = 'rightclick'     if hash.e is 'contextmenu' and Browser is 'Konqueror'
      hash.r = 'DOMMouseScroll' if hash.e is 'mousewheel'  and Browser is 'Gecko'

      # making the event handler wrapper, basically it wraps
      # the event and calls the original function in a correct context
      hash.w = (event)->
        event = new Event(event)
        args  = (if hash.n then [] else [event]).concat(hash.a)
        event.stop() if hash.c.apply(instance, args) is false
        return # nothing

      # attaching the actual event listener
      instance._.addEventListener(hash.r, hash.w, false)

    Array.prototype.push.call(this, hash)


  # hijacking the Array#splice method to remove
  # the actual dom event-listeners
  list.splice = (position) ->
    hash = this[position]

    instance._.removeEventListener(hash.r, hash.w, false)

    Array.prototype.splice.call(this, position, 1)


  # return the list
  instance._listeners = list
```
