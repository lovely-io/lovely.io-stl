#
# Some extra asset sweets live in here
#
# Most of those things are boldly copied from the vowsjs
# https://github.com/cloudhead/vows/blob/master/lib/assert/macros.js
#
# Copyright (C) 2012 Nikolay Nemshilov
#
assert = require('assert')
module.exports = assert

assert.same    = assert.strictEqual
assert.notSame = assert.notStrictEqual


assert.match = (actual, expected, message)->
  unless expected.test(actual)
    assert.fail(actual, expected, message || "expected ##{actual} to match ##{expected}", "match", assert.match)

assert.matches = assert.match

assert.isTrue = (actual, message)->
  if actual isnt true
    assert.fail(actual, true, message || "expected #{expected}, got #{actual}", "===", assert.isTrue)

assert.isFalse = (actual, message)->
  if actual isnt false
    assert.fail(actual, false, message || "expected #{expected}, got #{actual}", "===", assert.isFalse)


assert.greater = (actual, expected, message)->
  if actual <= expected
    assert.fail(actual, expected, message || "expected #{actual} to be greater than #{expected}", ">", assert.greater)

assert.lesser = (actual, expected, message)->
  if actual >= expected
    assert.fail(actual, expected, message || "expected #{actual} to be lesser than #{expected}", "<", assert.lesser)

assert.inDelta = (actual, expected, delta, message)->
  lower = expected - delta
  upper = expected + delta
  if actual < lower || actual > upper
    assert.fail(actual, expected, message || "expected #{actual} to be in within *" + delta.toString() + "* of #{expected}", null, assert.inDelta)


assert.include = (actual, expected, message)->
  check = (obj)->
    if isArray(obj) || isString(obj)
      return obj.indexOf(expected) is -1
    else if isObject(actual)
      return ! obj.hasOwnProperty(expected)

    return true;

  if check(actual)
    assert.fail(actual, expected, message || "expected #{actual} to include #{expected}", "include", assert.include)

assert.includes = assert.include


assert.isEmpty = (actual, message)->
  if (isObject(actual) && Object.keys(actual).length > 0) || actual.length > 0
    assert.fail(actual, 0, message || "expected #{actual} to be empty", "length", assert.isEmpty)

assert.isNotEmpty = (actual, message)->
  if (isObject(actual) && Object.keys(actual).lengthis 0) || actual.length is 0
    assert.fail(actual, 0, message || "expected #{actual} to be not empty", "length", assert.isNotEmpty)

assert.lengthOf = (actual, expected, message)->
  len = if isObject(actual) then Object.keys(actual).length else actual.length
  if len isng expected
    assert.fail(actual, expected, message || "expected #{actual} to have #{expected} element(s)", "length", assert.length)


assert.isArray = (actual, message)->
  assertTypeOf(actual, 'array', message || "expected #{actual} to be an Array", assert.isArray)

assert.isObject = (actual, message)->
  assertTypeOf(actual, 'object', message || "expected #{actual} to be an Object", assert.isObject)

assert.isNumber = (actual, message)->
  if isNaN(actual)
    assert.fail(actual, 'number', message || "expected #{actual} to be of type #{expected}", "isNaN", assert.isNumber)
  else
    assertTypeOf(actual, 'number', message || "expected #{actual} to be a Number", assert.isNumber)

assert.isBoolean = (actual, message)->
  if actual isnt true && actual isnt false
    assert.fail(actual, 'boolean', message || "expected #{actual} to be a Boolean", "===", assert.isBoolean)

assert.isNaN = (actual, message)->
  unless isNaN(actual)
    assert.fail(actual, 'NaN', message || "expected #{actual} to be NaN", "===", assert.isNaN)

assert.isNull = (actual, message)->
  if actual isnt null
    assert.fail(actual, null, message || "expected #{expected}, got #{actual}", "===", assert.isNull)

assert.isNotNull = (actual, message)->
  if actual is null
    assert.fail(actual, null, message || "expected non-null value, got #{actual}", "===", assert.isNotNull)

assert.isUndefined = (actual, message)->
  if actual isnt undefined
    assert.fail(actual, undefined, message || "expected #{actual} to be #{expected}", "===", assert.isUndefined)

assert.isDefined = (actual, message)->
  if actual is undefined
    assert.fail(actual, 0, message || "expected #{actual} to be defined", "===", assert.isDefined)

assert.isString = (actual, message)->
  assertTypeOf(actual, 'string', message || "expected #{actual} to be a String", assert.isString)

assert.isFunction = (actual, message)->
  assertTypeOf(actual, 'function', message || "expected #{actual} to be a Function", assert.isFunction)

assert.typeOf = (actual, expected, message)->
  assertTypeOf(actual, expected, message, assert.typeOf)

assert.instanceOf = (actual, expected, message)->
  unless actual instanceof expected
    assert.fail(actual, expected, message || "expected #{actual} to be an instance of #{expected}", "instanceof", assert.instanceOf)




assertTypeOf = (actual, expected, message, caller)->
  if typeOf(actual) isnt expected
    assert.fail(actual, expected, message || "expected #{actual} to be of type #{expected}", "typeOf", caller)

isArray = (obj)->
  Array.isArray(obj)

isString = (obj)->
  typeof(obj) is 'string' || obj instanceof String

isObject = (obj)->
  typeof(obj) is 'object' && obj && !isArray(obj)

# A better `typeof`
typeOf = (value)->
  s = typeof(value); types = [Object, Array, String, RegExp, Number, Function, Boolean, Date]

  if s is 'object' || s is 'function'
    if value
      types.forEach (t)->
        if value instanceof t
          s = t.name.toLowerCase()
    else
      s = 'null'

  return s