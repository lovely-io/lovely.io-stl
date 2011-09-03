#
# Utility function tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, util, Lovely} = require('../test_helper')

#
# A shortcut for the type check functions mass-testing
#
# @param {String} function name
# @param {Object} okays and fails
# @return void
#
assertTypeCheck = (name, options) ->
  def = topic: -> Lovely[name]

  for value in options.ok
    do (value) ->
      def["should return 'true' for: "+ util.inspect(value)] = (method) ->
        assert.isTrue(method(value))

  for value in options.fail
    do (value) ->
      def["should return 'false' for: "+ util.inspect(value)] = (method) ->
        assert.isFalse(method(value))

  def


describe 'Core Utils', module,
  "ext(a,b)":
    topic: -> Lovely.ext

    'should extend one object with another': (ext) ->
      a = a: 1
      b = b: 2
      c = ext(a, b)

      assert.deepEqual {a:1, b:2}, c
      assert.same      a, c

    "should accept 'null' as the second argument": (ext) ->
      assert.deepEqual {a: 1}, ext({a: 1}, null)

    "should accept 'undefined' as the second argument": (ext) ->
      assert.deepEqual {a: 1}, ext({a: 1}, undefined)

    "should skip the prototype values": (ext)->
      o1 = ->
      o2 = ->

      ext(o1, o2)

      assert.notSame o1.prototype, o2.prototype


  "bind":
    topic: ->
      result = this.result = {}

      return ->
        result.context = this
        result.args    = Lovely.A(arguments)

    '\r(context)':
      topic: (original) -> Lovely.bind(original, this.context = {})

      "should execute the original in the prebinded context": (callback) ->
        callback()

        assert.same this.result.context, this.context
        assert.deepEqual this.result.args, []

      "should execute the original even when called in a different context": (callback) ->
        callback.apply other: 'context'

        assert.same  this.result.context, this.context
        assert.deepEqual this.result.args, []

      "should bypass the arguments to the original function": (callback) ->
        callback(1,2,3)

        assert.same this.result.context, this.context
        assert.deepEqual this.result.args, [1,2,3]

    '\r(context, arg1, arg2,..)':
      topic: (original) -> Lovely.bind(original, this.context = {}, 1,2,3)

      "should pass the prebinded arguments into the original function": (callback) ->
        callback()

        assert.same this.result.context, this.context
        assert.deepEqual this.result.args, [1,2,3]

      "should handle additional arguments if specified": (callback) ->
        callback(4,5,6)

        assert.same  this.result.context, this.context
        assert.deepEqual this.result.args, [1,2,3,4,5,6]



  'trim(string)':
    topic: Lovely.trim("  boo hoo!\n\t ")

    "should trim the excessive spaces out": (string) ->
      assert.equal string, "boo hoo!"


  "isString(value)": assertTypeCheck('isString',
    ok:   ['']
    fail: [1, 2.2, true, false, null, undefined, [], {}, ->])

  "isNumber(value)": assertTypeCheck('isNumber',
    ok:   [1, 2.2]
    fail: ['11', '2.2', true, false, null, undefined, [], {}, NaN, ->])

  "isFunction(value)": assertTypeCheck('isFunction',
    ok:   [`function(){}`, new Function('return 1')]
    fail: ['', 1, 2.2, true, false, null, undefined, [], {}, /\s/])

  "isArray(value)": assertTypeCheck('isArray',
    ok:   [[], new Lovely.List()]
    fail: ['', 1, 2.2, true, false, null, undefined, {}, ->])

  "isObject(value)": assertTypeCheck('isObject',
    ok:   [{}]
    fail: ['', 1, 2.2, true, false, null, undefined, [], ->])


  "A(iterable)":
    topic: -> Lovely.A

    "should convert arguments into arrays": (A) ->
      dummy = -> arguments
      array = A(dummy(1,2,3))

      assert.isArray   array
      assert.deepEqual [1,2,3], array


  "L(iterable)":
    topic: -> Lovely.L

    "should make a List": (L) ->
      l = L([1,2,3])

      assert.instanceOf l, Lovely.List
      assert.deepEqual  l.toArray(), [1,2,3]


  "H(object)":
    topic: -> Lovely.H

    "should make a Hash": (H) ->
      hash = H(a:1)

      assert.instanceOf hash, Lovely.Hash
      assert.deepEqual  hash.toObject(), a:1

