#
# Utility function tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{util, Lovely} = require('../test_helper')

#
# A shortcut for the type check functions mass-testing
#
# @param {String} function name
# @param {Object} okays and fails
# @return void
#
assertTypeCheck = (name, options) ->
  ->
    for value in options.ok
      do (value) ->
        it "should return 'true' for: "+ util.inspect(value), ->
          Lovely[name](value).should.be.true

    for value in options.fail
      do (value) ->
        it "should return 'false' for: "+ util.inspect(value), ->
          Lovely[name](value).should.be.false


describe 'Core Utils', ->
  describe "ext(a,b)", ->
    ext = Lovely.ext

    it 'should extend one object with another', ->
      a = a: 1
      b = b: 2
      c = ext(a, b)

      c.should.eql     {a:1, b:2}
      c.should.be.same a

    it "should accept 'null' as the second argument", ->
      ext({a: 1}, null).should.eql {a: 1}

    it "should accept 'undefined' as the second argument", ->
      ext({a: 1}, undefined).should.eql {a: 1}

    it "should skip the prototype values", ->
      o1 = ->
      o2 = ->

      ext(o1, o2)

      o1.prototype.should.not.be.same o2.prototype


  describe "bind", ->
    bind     = Lovely.bind
    result   = {}
    original = ->
      result.context = this
      result.args    = Lovely.A(arguments)

    describe '\b(context)', ->
      callback = bind(original, context = {})

      it "should execute the original in the prebinded context", ->
        callback()

        result.context.should.be.same context
        result.args.should.eql        []

      it "should execute the original even when called in a different context", ->
        callback.apply other: 'context'

        result.context.should.be.same context
        result.args.should.eql        []

      it "should bypass the arguments to the original function", ->
        callback(1,2,3)

        result.context.should.be.same context
        result.args.should.eql        [1,2,3]

    describe '\b(context, arg1, arg2,..)', ->
      callback = bind(original, context = {}, 1,2,3)

      it "should pass the prebinded arguments into the original function", ->
        callback()

        result.context.should.be.same context
        result.args.should.eql        [1,2,3]

      it "should handle additional arguments if specified", ->
        callback(4,5,6)

        result.context.should.be.same context
        result.args.should.eql        [1,2,3,4,5,6]



  describe 'trim(string)', ->
    string = Lovely.trim("  boo hoo!\n\t ")

    it "should trim the excessive spaces out", ->
      string.should.be.equal "boo hoo!"


  describe "isString(value)", assertTypeCheck('isString',
    ok:   ['']
    fail: [1, 2.2, true, false, null, undefined, [], {}, ->])

  describe "isNumber(value)", assertTypeCheck('isNumber',
    ok:   [1, 2.2]
    fail: ['11', '2.2', true, false, null, undefined, [], {}, NaN, ->])

  describe "isFunction(value)", assertTypeCheck('isFunction',
    ok:   [`function(){}`, new Function('return 1')]
    fail: ['', 1, 2.2, true, false, null, undefined, [], {}, /\s/])

  describe "isArray(value)", assertTypeCheck('isArray',
    ok:   [[], new Lovely.List()]
    fail: ['', 1, 2.2, true, false, null, undefined, {}, ->])

  describe "isObject(value)", assertTypeCheck('isObject',
    ok:   [{}]
    fail: ['', 1, 2.2, true, false, null, undefined, [], ->])


  describe "A(iterable)", ->
    A = Lovely.A

    it "should convert arguments into arrays", ->
      dummy = -> arguments
      array = A(dummy(1,2,3))

      array.should.be.instanceOf Array
      array.should.eql           [1,2,3]


  describe "L(iterable)", ->
    L = Lovely.L

    it "should make a List", ->
      l = L([1,2,3])

      l.should.be.instanceOf Lovely.List
      l.toArray().should.eql [1,2,3]


  describe "H(object)", ->
    H = Lovely.H

    it "should make a Hash", ->
      hash = H(a:1)

      hash.should.be.instanceOf Lovely.Hash
      hash.toObject().should.eql a:1

