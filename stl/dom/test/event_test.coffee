#
# The `Event` unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

describe 'Event', ->
  $ = Event = window = document = null

  before Test.load module, (dom, win)->
    $        = dom
    Event    = $.Event
    window   = win
    document = win.document

  describe "constructor", ->

    it "should copy properties from a raw dom-event", ->
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

      event.type.should.equal     raw.type
      event.which.should.equal    raw.which
      event.keyCode.should.equal  raw.keyCode
      event.pageX.should.equal    raw.pageX
      event.pageY.should.equal    raw.pageY
      event.altKey.should.equal   raw.altKey
      event.metaKey.should.equal  raw.metaKey
      event.ctrlKey.should.equal  raw.ctrlKey
      event.shiftKey.should.equal raw.shiftKey


    it "should wrap the target elements", ->
      target  = document.createElement('div')
      related = document.createElement('div')
      current = document.createElement('div')

      event = new Event
        target:        target
        relatedTarget: related
        currentTarget: current

      event.target.should.be.instanceOf        $.Element
      event.currentTarget.should.be.instanceOf $.Element
      event.relatedTarget.should.be.instanceOf $.Element

      event.target._.should.equal        target
      event.currentTarget._.should.equal current
      event.relatedTarget._.should.equal related

    it "should handle the webkit text-node triggered events", ->
      text    = document.createTextNode('boo')
      element = document.createElement('div')
      element.appendChild(text)

      event   = new Event(target: text)

      event.target._.should.equal element

    it "should allow to create events just by name", ->
      event = new Event('my-event')

      event.should.be.instanceOf Event
      event.type.should.equal    'my-event'
      event._.should.eql         type: 'my-event'

    it "should copy custom properties to the custom events", ->
      event = new Event('my-event', myProperty: 'my-value')

      event.myProperty.should.equal 'my-value'
      event._.should.eql
        type:       'my-event'
        myProperty: 'my-value'



  describe "#stopPropagation()", ->

    it "should call 'stopPropagation()' on raw event when available", ->
      raw   = type: 'click', stopPropagation: -> @called = true
      event = new Event(raw)

      event.stopPropagation()

      raw.called.should.be.true
      (raw.cancelBubble is undefined).should.be.true

    it "should set the @stopped = true property", ->
      event = new Event('my-event')

      event.stopPropagation()

      event.stopped.should.be.true

    it "should return the event itself back", ->
      event = new Event('my-event')
      event.stopPropagation().should.equal event

  describe "#preventDefault()", ->

    it "should call 'preventDefault()' on a raw event when available", ->
      raw   = type: 'click', preventDefault: -> @called = true
      event = new Event(raw)

      event.preventDefault()

      raw.called.should.be.true
      (raw.returnValue is undefined).should.be.true

    it "should return the event itself back to the code", ->
      event = new Event('my-event')
      event.preventDefault().should.equal event

  describe "#stop()", ->

    it "should call 'preventDefault' and 'stopPropagation' methods", ->
      event = new Event('my-event')
      event.stopPropagation = -> @stopped   = true; return @
      event.preventDefault  = -> @prevented = true; return @

      event.stop()

      event.stopped.should.be.true
      event.prevented.should.be.true

    it "should return event itself back to the code", ->
      event = new Event('my-event')
      event.stop().should.equal event


  describe "#position()", ->

    it "should return the event's position in a standard x:NNN, y:NNN hash", ->
      event = new Event pageX: 222, pageY: 444

      event.position().should.eql x: 222, y: 444

  describe "#offset()", ->

    it "should return event's relative position in a standard x:NNN, y:NNN hash", ->
      target = new $.Element('div')
      target.position = -> x: 200, y: 300
      event  = new Event type: 'click', target: target, pageX: 250, pageY: 360

      event.offset().should.eql x: 50, y: 60

    it "should return 'null' if target is not an element", ->
      event = new Event type: 'click', target: new $.Document(document)

      (event.offset() is null).should.be.true

  describe "#find('css-rule')", ->

    it "should return 'null' if there is no 'target' property", ->
      event = new Event('my-event')
      (event.find('something') is null).should.be.true
