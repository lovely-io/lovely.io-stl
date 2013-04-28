#
# The events handling interface unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

eval(Test.build(module))
Lovely = this.Lovely


describe 'Events',
  # a dummy class to test the interface
  Dummy = new Lovely.Class
    include: Lovely.Events
    method:  -> # some dummy method


  describe "#on", ->

    describe "\b('event', callback)", ->
      dummy  = new Dummy()
      object = dummy.on('event', fun = ->)

      it "should return the same object back", ->
        object.should.equal dummy

      it "should start listen to the 'event'", ->
        object.ones('event', fun).should.be.true

    describe "\b('event', 'callback', arg1, arg2, arg3)", ->
      object = new Dummy().on('event', 'method', 1, 2, 3)

      it "should start listen to the 'event' with the 'method'", ->
        object.ones('event', object.method).should.be.true

      it "should stash the additional arguments for later use", ->
        object._listeners[0].a.should.eql [1,2,3]

    describe "\b('event1,event2', callback)", ->
      object = new Dummy().on('event1,event2', fun = ->)

      it "should start listening to the event1", ->
        object.ones('event1', fun).should.be.true

      it "should start listening to the event2", ->
        object.ones('event2', fun).should.be.true

    describe "\b({event1: callback1, event2: callback2})", ->
      object = new Dummy().on(event1: (fn1 = ->), event2: (fn2 = ->))

      it "should start listening to the event1", ->
        object.ones('event1', fn1).should.be.true

      it "should start listening to the event2", ->
        object.ones('event2', fn2).should.be.true


  describe "#ones", ->

    describe "\b('event')", ->
      dummy = new Dummy()

      it "should return 'false' by default", ->
        dummy.ones('something').should.be.false

      it "should return 'true' when listens to the event", ->
        dummy.on('event', ->).ones('event').should.be.true

    describe "\b('event', callback)", ->
      object = new Dummy().on('event', fun = ->)

      it "should say 'true' for used callback", ->
        object.ones('event', fun).should.be.true

      it "should say 'false' for another callback", ->
        object.ones('event', ->).should.be.false

    describe "\b(callback)", ->
      object = new Dummy().on('event', cb = ->)

      it "should say 'true' for used callback", ->
        object.ones(cb).should.be.true

      it "should say 'false' for another callback", ->
        object.ones(->).should.be.false


  describe "#no", ->

    describe "\b('event')", ->
      dummy = this.dummy = new Dummy()
        .on('event', ->)
        .on('other', ->)
      object = dummy.no('event')

      it "should return the same object back", ->
        object.should.be.equal dummy

      it "should stop listening to the event", ->
        object.ones('event').should.be.false

      it "should not touch the 'other' event", ->
        object.ones('other').should.be.true

    describe "\b('event', callback)", ->
      object = new Dummy()
        .on('event', cb1 = ->)
        .on('event', cb2 = ->)
        .no('event', cb1)

      it "should stop listening to the first callback", ->
        object.ones('event', cb1).should.be.false

      it "should keep listening to the second callback", ->
        object.ones('event', cb2).should.be.true

    describe "\b(callback)", ->
      object = new Dummy()
        .on('event1,event2', cb1 = ->)
        .on('event1,event2', cb2 = ->)
        .no(cb1)

      it "should listening all events for the callback", ->
        object.ones('event1', cb1).should.be.false
        object.ones('event2', cb1).should.be.false

      it "should not detach other callbacks", ->
        object.ones('event1', this.cb2).should.be.true
        object.ones('event2', this.cb2).should.be.true

    describe "\b('event1,event2')", ->
      object = new Dummy()
        .on('event1,event2,event3', cb = ->)
        .no('event1,event2')

      it "should stop listening to the 'event1'", ->
        object.ones('event1').should.be.false

      it "should stop listening to the 'event2'", ->
        object.ones('event2').should.be.false

      it "should keep listening to the 'event3'", ->
        object.ones('event3').should.be.true

    describe "\b({event1: callback1, event2: callback2})", ->
      object = new Dummy()
        .on(event1: (cb1 = ->), event2: (cb2 = ->), event3: (cb3 = ->))
        .no(event1: cb1, event2: cb2)

      it "should stop listening to the 'event1'", ->
        object.ones('event1').should.be.false

      it "should stop listening to the 'event2'", ->
        object.ones('event2').should.be.false

      it "should keep listening to the 'event3'", ->
        object.ones('event3').should.be.true



  describe "#emit", ->

    describe "\b('event')", ->
      result = this.result = {}
      dummy  = new Dummy().on('event', -> result.scope = this)
      object = dummy.emit('event')

      it "should return the same object back", ->
        object.should.be.equal dummy

      it "should call the listener in the scope of the object", ->
        result.scope.should.be.equal object

    describe "\b('event', arg1, arg2, arg3)", ->
      result = {}
      object = new Dummy()
        .on('event', -> result.args = Lovely.A(arguments))
        .emit('event', 1, 2, 3)

      it "should pass the arguments into the listener", ->
        result.args.should.eql [1,2,3]




