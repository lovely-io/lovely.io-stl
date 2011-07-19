#
# The string extensions unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

describe "Function extensions", module,

  "#bind(scope[, arg, ...])":
    "should make a proxy function that will call the original in given scope":->
      scope    = null
      original = -> scope = @; return "value"
      object   = {}
      proxy    = original.bind(object)

      assert.notSame object,  proxy
      assert.equal   "value", proxy()
      assert.same    object,  scope

    "should bypass any arguments into the original function": ->
      args     = null
      original = -> args = Lovely.A(arguments)
      proxy    = original.bind({})

      assert.deepEqual [1,2,3], proxy(1,2,3)

    "should left curry any binded arguments": ->
      args     = null
      original = -> args = Lovely.A(arguments)
      proxy    = original.bind({}, 1, 2)

      assert.deepEqual [1,2,3], proxy(3)

  "#curry(arg[, arg, ...])":
    "should create a new proxy function that will call the original": ->
      called   = false
      original = -> called = true; "result"
      proxy    = original.curry(1,2,3)

      assert.notSame original, proxy
      assert.equal   "result", proxy()
      assert.isTrue  called

    "should left-curry additional arguments": ->
      args     = null
      original = -> args = Lovely.A(arguments)
      proxy    = original.curry(1,2)

      assert.deepEqual [1,2,3], proxy(3)

  "#rcurry(arg[, arg, ..])":
    "should create a new proxy function that will call the original": ->
      called   = false
      original = -> called = true; "result"
      proxy    = original.rcurry(1,2,3)

      assert.notSame original, proxy
      assert.equal   "result", proxy()
      assert.isTrue  called

    "should left-curry additional arguments": ->
      args     = null
      original = -> args = Lovely.A(arguments)
      proxy    = original.rcurry(1,2)

      assert.deepEqual [3,1,2], proxy(3)


  "#delay(ms, [, arg, ...])":
    "should initialize a delayed call": ->
      stash = global.setTimeout
      args  = null
      global.setTimeout = -> args = Lovely.A(arguments); 12345

      original = ->
      marker   = original.delay(1000)

      assert.equal      args[1],  1000
      assert.instanceOf args[0],  Function
      assert.instanceOf marker,   Number
      assert.equal      marker,   12345
      assert.instanceOf marker.cancel, Function

      global.setTimeout = stash


  "#periodical(ms, [, arg, ...])":
    "should initialize periodical calls": ->
      stash = global.setInterval
      args  = null
      global.setInterval = -> args = Lovely.A(arguments); 12345

      original = ->
      marker   = original.periodical(1000)

      assert.equal      args[1],  1000
      assert.instanceOf args[0],  Function
      assert.instanceOf marker,   Number
      assert.equal      marker,   12345
      assert.instanceOf marker.stop, Function

      global.setInterval = stash



