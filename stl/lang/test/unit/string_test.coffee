#
# The string extensions unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

describe "String extensions", module,
  "#includes(substring)":
    "should return 'true' if a string includes a substring": ->
      assert.isTrue "super-duper".includes('super')
      assert.isTrue "super-duper".includes('duper')
      assert.isTrue "super-duper".includes('er-du')

    "should return 'false' if a string doesn't include given substring": ->
      assert.isFalse "super-duper".includes("uber")


  "#endsWith(substring)":
    "should return 'true' when the string ends with a substring": ->
      assert.isTrue "super-duper".endsWith("duper")

    "should return 'false' when the string doesn't end with a substring": ->
      assert.isFalse "super-duper".endsWith("super")

  "#startsWith(substring)":
    "should return 'true' when the string starts with a substring": ->
      assert.isTrue "super-duper".startsWith("super")

    "should return 'false' when the string doesn't starts with a substring": ->
      assert.isFalse "super-duper".startsWith("duper")


  "#toInt()":
    "should convert a string into a number": ->
      assert.same "123".toInt(), 123

    "should convert a string into an integer with a custom base": ->
      assert.same "ff".toInt(16), 255

    "should return NaN for an inconvertible strings": ->
      assert.isNaN "asdf".toInt()

  "#toFloat()":
    "should convert a string into a float number": ->
      assert.same "12.3".toFloat(), 12.3

    "should return NaN for an inconvertible strings": ->
      assert.isNaN "asdf".toFloat()