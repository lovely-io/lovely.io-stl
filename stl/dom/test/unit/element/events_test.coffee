#
# The Element events handling module unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../../test_helper'

server.respond "/events.html": """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="test"></div>
    </body>
  </html>
  """

test_element = ->
  load_element "/events.html", this, "test"


describe "Element Events", module,
  "#on":
    topic: test_element

    "should attach event listeners": (element)->
      callback = ->
      element.on('click', callback)
      assert.isTrue element.ones('click', callback)


    "should actually listen to the events": (element)->
      event    = null
      context  = null

      element.on('click', (e) -> event = e; context = @)

      this.browser.fire 'click', element._

      assert.instanceOf event, this.Event

      assert.same event.target, element
      assert.same context,      element

    "should handle calls by name": (element)->
      element.setClass('')
      element.on('click', 'setClass', 'call-by-name')

      this.browser.fire 'click', element._

      assert.equal element._.className, 'call-by-name'

    "should stop event when the callback returns 'false'": (element)->
      event = null
      element.no('click').on('click', (e) -> event = e; false)

      this.browser.fire 'click', element._

      assert.isTrue event.stopped


    "should return the element itself back": (element)->
      assert.same element.on('click', ->), element


  "#no":
    topic: test_element

    "should remove event listener": (element)->
      event = null
      element.on('click', (e)-> event)

      element.no('click')

      this.browser.fire 'click', element._

      assert.isNull event

    "should return element itself back to the code": (element)->
      assert.same element.no('click'), element


  "#ones":
    topic: test_element

    "should return 'true' for registered events": (element)->
      callback = ->
      element.on('click', callback)

      assert.isTrue element.ones('click')
      assert.isTrue element.ones('click', callback)


    "should return 'false' for unregistered events": (element)->
      callback = ->
      element.on('click', callback)

      assert.isFalse element.ones('mouseover')
      assert.isFalse element.ones('click', other_callback = ->)


  "#emit":
    topic: test_element

    "should emit an event on an element": (element)->
      event = null
      element.on('click', (e) -> event = e)
      element.emit('click')

      assert.instanceOf event,  this.Event
      assert.equal event.type,  'click'
      assert.same  event.target, element

    "should attach any sort of event properties": (element)->
      event = null
      element.on('click', (e) -> event = e)
      element.emit('click', attr1: 1, attr2: 2)

      assert.equal event.attr1, 1
      assert.equal event.attr2, 2


    "should bypass the event to it's parent": (element)->
      event1 = null
      event2 = null
      body   = new this.Element(this.document.body)

      element.on 'click', (e) -> event1 = e
      body.on    'click', (e) -> event2 = e

      element.emit('click')

      assert.instanceOf event1, this.Event
      assert.same       event1, event2


    "should not bypass the event if it was stopped": (element)->
      event1 = null
      event2 = null
      body   = new this.Element(this.document.body)

      element.on 'click', (e) -> event1 = e.stop()
      body.on    'click', (e) -> event2 = e

      element.emit('click')

      assert.instanceOf event1, this.Event
      assert.isNull     event2


    "should change the 'currentTarget' property as the event bubbles": (element)->
      current1 = null
      current2 = null
      body     = new this.Element(this.document.body)

      element.no 'click'
      element.on 'click', (e) -> current1 = e.currentTarget
      body.on    'click', (e) -> current2 = e.currentTarget

      element.emit('click')

      assert.same current1, element
      assert.same current2, body


    "should return the element itself back to the code": (element)->
      assert.same element.emit('click'), element