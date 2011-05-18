#
# The events handling interface unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, Lovely} = require('../test_helper')


# a dummy class to test the interface
Dummy = new Lovely.Class
  include: Lovely.Events
  method: -> # some dummy method


describe 'Events', module,

  "#on":

    "\b('event', callback)":
      topic: -> this.dummy = new Dummy().on('event', this.cb = ->)

      "should return the same object back": (object) ->
        assert.same object, this.dummy

      "should start listen to the 'event'": (object) ->
        assert.isTrue object.ones('event', this.cb)

    "\b('event', 'callback', arg1, arg2, arg3)":
      topic: -> new Dummy().on('event', 'method', 1, 2, 3)

      "should start listen to the 'event' with the 'method'": (object) ->
        assert.isTrue object.ones('event', object.method)

      "should stash the additional arguments for later use": (object) ->
        assert.deepEqual object._listeners[0].a, [1,2,3]

    "\b('event1 event2', callback)":
      topic: -> new Dummy().on('event1 event2', this.cb = ->)

      "should start listening to the event1": (object) ->
        assert.isTrue object.ones('event1', this.cb)

      "should start listening to the event2": (object) ->
        assert.isTrue object.ones('event2', this.cb)

    "\b({event1: callback1, event2: callback2})":
      topic: -> new Dummy()
        .on(event1: (this.cb1 = ->), event2: (this.cb2 = ->))

      "should start listening to the event1": (object) ->
        assert.isTrue object.ones('event1', this.cb1)

      "should start listening to the event2": (object) ->
        assert.isTrue object.ones('event2', this.cb2)


  "#ones":

    "\b('event')":
      topic: -> this.dummy = new Dummy

      "should return 'false' by default": ->
        assert.isFalse this.dummy.ones('something')

      "should return 'true' when listens to the event": ->
        object = this.dummy.on('event', ->)
        assert.isTrue object.ones('event')

    "\b('event', callback)":
      topic: -> new Dummy().on('event', this.cb = ->)

      "should say 'true' for used callback": (object) ->
        assert.isTrue object.ones('event', this.cb)

      "should say 'false' for another callback": (object) ->
        assert.isFalse object.ones('event', ->)

    "\b(callback)":
      topic: -> new Dummy().on('event', this.cb = ->)

      "should say 'true' for used callback": (object) ->
        assert.isTrue object.ones(this.cb)

      "should say 'false' for another callback": (object) ->
        assert.isFalse object.ones(->)


  "#no":

    "\b('event')":
      topic: -> this.dummy = new Dummy()
        .on('event', ->)
        .on('other', ->)
        .no('event')

      "should return the same object back": (object) ->
        assert.same object, this.dummy

      "should stop listening to the event": (object) ->
        assert.isFalse object.ones('event')

      "should not touch the 'other' event": (object) ->
        assert.isTrue object.ones('other')

    "\b('event', callback)":
      topic: -> new Dummy()
        .on('event', this.cb1 = ->)
        .on('event', this.cb2 = ->)
        .no('event', this.cb1)

      "should stop listening to the first callback": (object) ->
        assert.isFalse object.ones('event', this.cb1)

      "should keep listening to the second callback": (object) ->
        assert.isTrue object.ones('event', this.cb2)

    "\b(callback)":
      topic: -> new Dummy()
        .on('event1 event2', this.cb1 = ->)
        .on('event1 event2', this.cb2 = ->)
        .no(this.cb1)

      "should listening all events for the callback": (object)->
        assert.isFalse object.ones('event1', this.cb1)
        assert.isFalse object.ones('event2', this.cb1)

      "should not detach other callbacks": (object)->
        assert.isTrue object.ones('event1', this.cb2)
        assert.isTrue object.ones('event2', this.cb2)

    "\b('event1 event2')":
      topic: -> new Dummy()
        .on('event1 event2 event3', this.cb = ->)
        .no('event1 event2')

      "should stop listening to the 'event1'": (object) ->
        assert.isFalse object.ones('event1')

      "should stop listening to the 'event2'": (object) ->
        assert.isFalse object.ones('event2')

      "should keep listening to the 'event3'": (object) ->
        assert.isTrue object.ones('event3')

    "\b({event1: callback1, event2: callback2})":
      topic: -> new Dummy()
        .on(event1: (this.cb1 = ->), event2: (this.cb2 = ->), event3: (this.cb3 = ->))
        .no(event1: this.cb1, event2: this.cb2)

      "should stop listening to the 'event1'": (object) ->
        assert.isFalse object.ones('event1')

      "should stop listening to the 'event2'": (object) ->
        assert.isFalse object.ones('event2')

      "should keep listening to the 'event3'": (object) ->
        assert.isTrue object.ones('event3')



  "#emit":

      "\b('event')":
        topic: ->
          result = this.result = {}
          this.dummy = new Dummy()
            .on('event', -> result.scope = this)
            .emit('event')

        "should return the same object back": (object) ->
          assert.same object, this.dummy

        "should call the listener in the scope of the object": (object) ->
          assert.same this.result.scope, object

      "\b('event', arg1, arg2, arg3)":
        topic: ->
          result = this.result = {}
          new Dummy()
            .on('event', -> result.args = Lovely.A(arguments))
            .emit('event', 1, 2, 3)

          "should pass the arguments into the listener": (object) ->
            assert.deepEqual this.result.args, [1,2,3]




