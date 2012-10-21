#
# The standard events handling interface mixin
#
#     MyClass = new core.Class
#       inclunde: core.Events
#
#     my = new MyClass
#
#     my.on 'event', (one, two, three)->
#       console.log(one, two, three)
#
#     my.emit 'event', 1, 2, 3
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
Events =
  _listeners: null # this object listeners stash

  #
  # Adds event listeners
  #
  #     object.on 'event', callback
  #     object.on 'event1,event2,event3', callback
  #     object.on event1: callback1, event2: callback2
  #     object.on 'event', 'methodname'[, arg1, arg2, ..]
  #
  # @return {Class} this
  #
  on: ->
    args     = Array_slice.call(arguments, 2)
    events   = arguments[0]
    callback = arguments[1]
    by_name  = false

    if typeof(callback) is 'string'
      callback = this[callback]
      by_name  = true

    listeners = if @_listeners is null then (@_listeners = []) else @_listeners

    if typeof(events) is 'string'
      for event in events.split(',')
        listeners.push
          e: event     # event name
          c: callback  # callback function reference
          a: args      # remaining arguments list
          n: by_name   # a marker if the callback was specified as a method-name

    else if typeof(events) is 'object'
      for event of events
        @on event, events[event]

    this

  #
  # Removes event listeners
  #
  #     object.no 'event'
  #     object.no 'event1,event2'
  #     object.no callback
  #     object.no 'event', callback
  #     object.no event1: callback1, event2: callback2
  #     object.no 'event', 'methodname'
  #
  # @return {Class} this
  #
  no: ->
    args     = Array_slice.call(arguments, 2)
    events   = arguments[0]
    callback = arguments[1]
    callback = this[callback] if typeof(callback) is 'string'

    listeners = if @_listeners is null then (@_listeners = []) else @_listeners

    switch typeof(events)
      when 'string'
        for event in events.split(',')
          index = 0
          while index < listeners.length
            listeners.splice index--, 1 if listeners[index].e is
              event and (listeners[index].c is callback or callback is undefined)
            index++

      when 'function'
        index = 0
        while index < listeners.length
          if listeners[index].c is events
            listeners.splice index--, 1
          index++

      when 'object'
        for event of events
          @no event, events[event]

    this

  #
  # Checks if this object listens to the events
  #
  #     object.ones 'event'
  #     object.ones 'event1,event2'
  #     object.ones callback
  #     object.ones 'event', callback
  #     object.ones event1: callback1, event2: callback2
  #     object.ones 'event', 'methodname'
  #
  # __NOTE__: if several event names are specified then it
  #       will check if _any_ of them are satisfied
  #
  # @return {boolean} check result
  #
  ones: ->
    result   = 0
    args     = Array_slice.call(arguments, 2)
    events   = arguments[0]
    callback = arguments[1]
    callback = this[callback] if typeof(callback) is 'string'

    listeners = if @_listeners is null then (@_listeners = []) else @_listeners

    switch typeof(events)
      when 'string'
        for event in events.split(',')
          for entry in listeners
            result |= entry.e is event and (
              entry.c is callback or callback is undefined)

      when 'function'
        for entry in listeners
          result |= entry.c is events

      when 'object'
        for event of events
          result |= @ones event, events[event]

    result is 1 # converting to boolean after the `|=` operations

  #
  # Triggers an event on the object
  #
  #     object.emit 'event'
  #     object.emit 'event', arg1, arg2, arg3
  #
  # @return {Class} this
  #
  emit: ->
    args  = A(arguments)
    event = args.shift()

    for entry in this._listeners || []
      if entry.e is event
        entry.c.apply(this, entry.a.concat(args))

    this

