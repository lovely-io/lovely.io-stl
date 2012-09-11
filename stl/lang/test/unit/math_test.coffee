#
# The Math extensions unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
Lovely = require('../../../../cli/lovely')
{Test, assert} = Lovely

eval(Test.build(module))


describe "Math extensions", ->

  describe "#random()", ->
    it "should return a random float between 0 and 1", ->
      prev_random = null

      for i in [0..100]
        random = Math.random()

        assert.notEqual random, prev_random
        assert.isTrue   random > 0
        assert.isTrue   random < 1
        assert.notEqual Math.round(random), random # checking if it's a float

        prev_random = random

  describe "#random(limit)", ->
    it "should generate a random integer between 0 and the limit", ->
      for i in [0..100]
        random = Math.random(10)

        assert.isTrue   random >= 0
        assert.isTrue   random <= 10
        assert.equal    Math.round(random), random # checking if it's an integer

  describe "#random(min, max)", ->
    it "should generate a random integer between the min and max limits", ->
      for i in [0..100]
        random = Math.random(10, 20)

        assert.isTrue   random >= 10
        assert.isTrue   random <= 20
        assert.equal    Math.round(random), random # checking if it's an integer

