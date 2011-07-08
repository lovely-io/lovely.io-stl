#
# The `Event` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, load} = require('../test_helper')

Event = ->
  load "/test.html", this, (dom)-> dom.Event


describe 'Event', module,
  "constructor":
    topic: Event

    "should copy properties from a raw dom-event": (Event)->
      raw =
        type:     'check'
        pageX:    222
        pageY:    444
        which:    2
        keyCode:  88
        altKey:   false
        metaKey:  true
        ctrlKey:  false
        shiftKey: true

      event = new Event(raw)

      assert.equal event.type,     raw.type
      assert.equal event.which,    raw.which
      assert.equal event.keyCode,  raw.keyCode
      assert.equal event.pageX,    raw.pageX
      assert.equal event.pageY,    raw.pageY
      assert.equal event.altKey,   raw.altKey
      assert.equal event.metaKey,  raw.metaKey
      assert.equal event.ctrlKey,  raw.ctrlKey
      assert.equal event.shiftKey, raw.shiftKey


    "should wrap the target elements": (Event)->
      target  = this.document.createElement('div')
      related = this.document.createElement('div')
      current = this.document.createElement('div')

      event = new Event
        target:        target
        relatedTarget: related
        currentTarget: current

      assert.instanceOf event.target,        this.Element
      assert.instanceOf event.currentTarget, this.Element
      assert.instanceOf event.relatedTarget, this.Element

      assert.same event.target._,        target
      assert.same event.currentTarget._, current
      assert.same event.relatedTarget._, related

    "should handle the webkit text-node triggered events": (Event)->
      text    = this.document.createTextNode('boo')
      element = this.document.createElement('div')
      element.appendChild(text)

      event   = new Event(target: text)

      assert.same event.target._, element

    "should allow to create events just by name": (Event)->
      event = new Event('my-event')

      assert.instanceOf event, Event
      assert.equal      event.type, 'my-event'
      assert.deepEqual  event._,    type: 'my-event'

    "should copy custom properties to the custom events": (Event)->
      event = new Event('my-event', myProperty: 'my-value')

      assert.equal event.myProperty, 'my-value'
      assert.deepEqual event._,
        type:       'my-event'
        myProperty: 'my-value'



  "#stopPropagation()":
    topic: Event

    "should call 'stopPropagation()' on raw event when available": (Event)->
      raw   = type: 'click', stopPropagation: -> @called = true
      event = new Event(raw)

      event.stopPropagation()

      assert.isTrue      raw.called
      assert.isUndefined raw.cancelBubble

    "should set the @stopped = true property": (Event)->
      event = new Event('my-event')

      event.stopPropagation()

      assert.isTrue event.stopped

    "should return the event itself back": (Event)->
      event = new Event('my-event')
      assert.same event.stopPropagation(), event

  "#preventDefault":
    topic: Event

    "should call 'preventDefault()' on a raw event when available": (Event)->
      raw   = type: 'click', preventDefault: -> @called = true
      event = new Event(raw)

      event.preventDefault()

      assert.isTrue      raw.called
      assert.isUndefined raw.returnValue

    "should return the event itself back to the code": (Event)->
      event = new Event('my-event')
      assert.same event.preventDefault(), event

  "#stop()":
    topic: Event

    "should call 'preventDefault' and 'stopPropagation' methods": (Event)->
      event = new Event('my-event')
      event.stopPropagation = -> @stopped   = true; return @
      event.preventDefault  = -> @prevented = true; return @

      event.stop()

      assert.isTrue event.stopped
      assert.isTrue event.prevented

    "should return event itself back to the code": (Event)->
      event = new Event('my-event')
      assert.same event.stop(), event


  "#position()":
    topic: Event

    "should return the event's position in a standard x:NNN, y:NNN hash": (Event)->
      event = new Event pageX: 222, pageY: 444

      assert.deepEqual event.position(), x: 222, y: 444

  "#offset()":
    topic: Event

    "should return event's relative position in a standard x:NNN, y:NNN hash": (Event)->
      target = new this.Element('div')
      target.position = -> x: 200, y: 300
      event  = new Event type: 'click', target: target, pageX: 250, pageY: 360

      assert.deepEqual event.offset(), x: 50, y: 60

    "should return 'null' if target is not an element": (Event)->
      event = new Event type: 'click', target: new this.Document(this.document)

      assert.isNull event.offset()

  "#find('css-rule')":
    topic: Event

    "should return 'null' if there is no 'target' property": (Event)->
      event = new Event('my-event')
      assert.isNull event.find('something')
