#
# The string extensions unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

describe "String extensions", module,

  "#abs()":
    "should return the number itself for positive values":->
      num = 16
      assert.equal num, num.abs()

    "should return the absolute value for negative numbers":->
      num = -16
      assert.equal 16, num.abs()

  "#round()":
    "should round 4.4 to 4": ->
      assert.equal 4, 4.4.round()

    "should round 4.6 to 5": ->
      assert.equal 5, 4.6.round()

    "should round a float to given size": ->
      assert.equal 4.44, 4.4444.round(2)
      assert.equal 4.45, 4.4466.round(2)

  "#ceil()":
    "should always round the number to biggest integer": ->
      assert.equal 5, 4.6.ceil()
      assert.equal 5, 4.1.ceil()

  "#floor()":
    "should always round the number to smallest integer": ->
      assert.equal 4, 4.1.floor()
      assert.equal 4, 4.9.floor()

  "#min(value)":
    "should return the number itself when it's bigger than the limit": ->
      assert.equal 4.44, 4.44.min(4)

    "should return the limit when the number is smaller than it":->
      assert.equal 4, 3.33.min(4)

  "#max(value)":
    "should return the number itself when it's smaller than the limit": ->
      assert.equal 2.22, 2.22.max(4)

    "should return the limit value if the number is bigger than that": ->
      assert.equal 4, 4.44.max(4)

  "#times(callback, scope)":
    "should call the callback with every number from 0 to it's value":->
      numbers = []
      4.0.times (i)-> numbers.push(i)
      assert.deepEqual [0,1,2,3], numbers


  "#map(callback, scope)":
    "should return a list of results of calls on the callback":->
      assert.deepEqual [0,2,4,6], 4.0.map (i)-> i * 2

