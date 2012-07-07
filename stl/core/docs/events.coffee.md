The standard events handling interface mixin

    MyClass = new core.Class
      inclunde: core.Events

    my = new MyClass

    my.on 'event', (one, two, three)->
      console.log(one, two, three)

    my.emit 'event', 1, 2, 3

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
Events =
  _listeners: null # this object listeners stash
```

Adds event listeners

    object.on 'event', callback
    object.on 'event1,event2,event3', callback
    object.on event1: callback1, event2: callback2
    object.on 'event', 'methodname'[, arg1, arg2, ..]

@return {Class} this

```coffee-aside
  on: ->
    args     = A(arguments)
    events   = args.shift()
    callback = args.shift()
    callback = this[callback] if typeof(callback) is 'string'

    this._listeners is null && (this._listeners = [])

    switch typeof(events)
      when 'string'
        for event in events.split(',')
          this._listeners.push
            e: event     # event name
            c: callback  # callback function reference
            a: args      # remaining arguments list
            n: typeof(arguments[1]) is 'string' # a marker if the callback was specified as a method-name

      when 'object'
        for event of events
          this.on event, events[event]

    this
```

Removes event listeners

    object.no 'event'
    object.no 'event1,event2'
    object.no callback
    object.no 'event', callback
    object.no event1: callback1, event2: callback2
    object.no 'event', 'methodname'

@return {Class} this

```coffee-aside
  no: ->
    args     = A(arguments)
    events   = args.shift()
    callback = args.shift()
    callback = this[callback] if typeof(callback) is 'string'

    this._listeners is null && (this._listeners = [])

    switch typeof(events)
      when 'string'
        for event in events.split(',')
          index = 0
          while index < this._listeners.length
            this._listeners.splice index--, 1 if this._listeners[index].e is
              event and (this._listeners[index].c is callback or callback is undefined)
            index++

      when 'function'
        index = 0
        while index < this._listeners.length
          if this._listeners[index].c is events
            this._listeners.splice index--, 1
          index++

      when 'object'
        for event of events
          this.no event, events[event]

    this
```

Checks if this object listens to the events

    object.ones 'event'
    object.ones 'event1,event2'
    object.ones callback
    object.ones 'event', callback
    object.ones event1: callback1, event2: callback2
    object.ones 'event', 'methodname'

__NOTE__: if several event names are specified then it
      will check if _any_ of them are satisfied

@return {boolean} check result

```coffee-aside
  ones: ->
    result   = no
    args     = A(arguments)
    events   = args.shift()
    callback = args.shift()
    callback = this[callback] if typeof(callback) is 'string'

    this._listeners is null && (this._listeners = [])

    switch typeof(events)
      when 'string'
        for event in events.split(',')
          for entry in this._listeners
            result |= entry.e is event and (
              entry.c is callback or callback is undefined)

      when 'function'
        for entry in this._listeners
          result |= entry.c is events

      when 'object'
        for event of events
          result |= this.ones event, events[event]

    result is 1 # converting to boolean after the `|=` operations
```

Triggers an event on the object

    object.emit 'event'
    object.emit 'event', arg1, arg2, arg3

@return {Class} this

```coffee-aside
  emit: ->
    args  = A(arguments)
    event = args.shift()

    for entry in this._listeners || []
      if entry.e is event
        entry.c.apply(this, entry.a.concat(args))

    this
```
