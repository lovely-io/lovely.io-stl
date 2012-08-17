#
# The Element events handling module unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Browser} = require('../../test_helper')

Browser.respond "/events.html": """
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

describe "Element Events", ->
  get = (callback)->
    (done)->
      Browser.open "/events.html", ($, window, browser)->
        element = new $.Element(window.document.getElementById('test'))
        callback(element, $, window, window.document, browser)
        done()

  describe "#on", ->

    it "should attach event listeners", get (element)->
      callback = ->
      element.on('click', callback)
      element.ones('click', callback).should.be.true


    it "should actually listen to the events", get (element, $, window, document, browser)->
      event    = null
      context  = null

      element.on('click', (e) -> event = e; context = @)

      browser.fire 'click', element._

      event.should.be.instanceOf $.Event

      event.target.should.equal element
      context.should.equal      element

    it "should handle calls by name", get (element, $, window, document, browser)->
      element.setClass('')
      element.on('click', 'setClass', 'call-by-name')

      browser.fire 'click', element._

      element._.className.should.equal 'call-by-name'

    it "should stop event when the callback returns 'false'", get (element, $, window, document, browser)->
      event = null
      element.no('click').on('click', (e) -> event = e; false)

      browser.fire 'click', element._

      event.stopped.should.be.true


    it "should return the element itself back", get (element)->
      element.on('click', ->).should.equal element


  describe "#no", ->

    it "should remove event listener", get (element, $, window, document, browser)->
      event = null
      element.on('click', (e)-> event)

      element.no('click')

      browser.fire 'click', element._

      (event is null).should.be.true

    it "should return element itself back to the code", get (element)->
      element.no('click').should.equal element


  describe "#ones", ->

    it "should return 'true' for registered events", get (element)->
      callback = ->
      element.on('click', callback)

      element.ones('click').should.be.true
      element.ones('click', callback).should.be.true


    it "should return 'false' for unregistered events", get (element)->
      callback = ->
      element.on('click', callback)

      element.ones('mouseover').should.be.false
      element.ones('click', other_callback = ->).should.be.false


  describe "#emit", ->

    it "should emit an event on an element", get (element, $)->
      event = null
      element.on('click', (e) -> event = e)
      element.emit('click')

      event.should.be.instanceOf $.Event
      event.type.should.equal    'click'
      event.target.should.equal  element

    it "should attach any sort of event properties", get (element)->
      event = null
      element.on('click', (e) -> event = e)
      element.emit('click', attr1: 1, attr2: 2)

      event.attr1.should.eql 1
      event.attr2.should.eql 2


    it "should bypass the event to it's parent", get (element, $, window, document)->
      event1 = null
      event2 = null
      body   = new $.Element(document.body)

      element.on 'click', (e) -> event1 = e
      body.on    'click', (e) -> event2 = e

      element.emit('click')

      event1.should.be.instanceOf $.Event
      event1.should.equal         event2


    it "should not bypass the event if it was stopped", get (element, $, window, document)->
      event1 = null
      event2 = null
      body   = new $.Element(document.body)

      element.on 'click', (e) -> event1 = e.stop()
      body.on    'click', (e) -> event2 = e

      element.emit('click')

      event1.should.be.instanceOf $.Event
      (event2 is null).should.be.true


    it "should change the 'currentTarget' property as the event bubbles", get (element, $, window, document)->
      current1 = null
      current2 = null
      body     = new $.Element(document.body)

      element.no 'click'
      element.on 'click', (e) -> current1 = e.currentTarget
      body.on    'click', (e) -> current2 = e.currentTarget

      element.emit('click')

      current1.should.equal element
      current2.should.equal body


    it "should return the element itself back to the code", get (element)->
      element.emit('click').should.equal element