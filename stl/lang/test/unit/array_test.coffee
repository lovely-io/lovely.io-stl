#
# The Array extensions unit tests
#
# Copyright (C) 2011-2102 Nikolay Nemshilov
#
Lovely = require('../../../../cli/lovely')
{Test, assert} = Lovely

eval(Test.build(module))

describe "Array extensions", ->

  describe "#size()", ->
    it "should return the array length", ->
      assert.equal [].size(),    0
      assert.equal [1].size(),   1
      assert.equal [1,2].size(), 2

  describe "#empty()", ->
    it "should return 'true' if an array is empty", ->
      assert.isTrue [].empty()

    it "should return 'false' if the array isn't empty", ->
      assert.isFalse [1].empty()
      assert.isFalse [null].empty()
      assert.isFalse [undefined].empty()

  describe "#clean()", ->
    it "should clean up the the array", ->
      array = [1,2,3]
      clean = array.clean()

      assert.same      array, clean
      assert.deepEqual array, []

  describe "#clone()", ->
    it "should make an array just as the original but in a different object", ->
      original = [1,2,3]
      clone    = original.clone()

      assert.notSame   clone, original
      assert.deepEqual clone, original

    it "should use the List class when cloned in there", ->
      original = new Lovely.List([1,2,3])
      clone    = original.clone()

      assert.instanceOf clone,           Lovely.List
      assert.deepEqual  clone.toArray(), original.toArray()


  describe "#first()", ->
    it "should return a first element on the list when called without arguments", ->
      assert.equal [1,2,3].first(), 1

    it "should return the first matching element if called with a callback function", ->
      assert.equal [1,2,3,4].first((i)-> i > 2), 3


  describe "#last()", ->
    it "should return a last element on the list when called without arguments", ->
      assert.equal [1,2,3].last(), 3

    # due some weird fuckup with Array.prototype.last
    #it "should return the last matching element if called with a callback function", ->
    #  assert.equal [1,2,3,4].last((i)-> i < 3), 2


  describe "#random()", ->
    it "should return a random item out of the array", ->
      array = [1,2,3,4,5]

      for i in [0..100]
        rand = array.random()
        assert.includes array, rand


  describe "#includes(item)", ->
    it "should return 'true' when the array includes the item", ->
      assert.isTrue [1,2,3].includes(1)
      assert.isTrue [1,2,3].includes(2)
      assert.isTrue [1,2,3].includes(3)

    it "should return 'false' when the array doesn't contains the item", ->
      assert.isFalse [1,2,3].includes(0)
      assert.isFalse [1,2,3].includes(4)


  describe "#walk(callback[, scope])", ->
    it "should apply the callback to every item on the list", ->
      assert.deepEqual [1,2,3].walk((i)-> i * 2), [2,4,6]

    it "should return the array itself back to the code", ->
      array = [1,2,3]
      assert.same array.walk((i)->i*2), array


  describe "#reject(callback, scope)", ->
    it "should reject items that pass the check in the callback", ->
      array  = [1,2,3,4,5]
      result = array.reject((i)-> i > 3)

      assert.deepEqual result, [1,2,3]
      assert.notSame   result, array

    it "should not wreak the List#reject calls by name", ->
      list = new Lovely.List(['a', ' ', 'b', 'c'])

      assert.deepEqual list.reject('blank').toArray(), ['a', 'b', 'c']


  describe "#without(item1[, item2])", ->
    it "should return a new array without the specified items", ->
      array  = [1,2,3,4,5]
      result = array.without(2,5)

      assert.deepEqual result, [1,3,4]
      assert.notSame   result, array

  describe "#compact()", ->
    it "should create a new array without 'null' and 'undefined' values", ->
      array  = [0,'', ' ', null, 'null', undefined, 'undefined', false]
      result = array.compact()

      assert.deepEqual result, [0, '', ' ', 'null', 'undefined', false]
      assert.notSame   result, array

  describe "#flatten()", ->
    it "should flatten down a multi-dimensional array", ->
      array  = [0, [1,2, [3, [4]]]]
      result = array.flatten()

      assert.deepEqual  result, [0,1,2,3,4]
      assert.notSame    result, array
      assert.instanceOf result, Array

    it "should work with Lovely.List instances", ->
      list   = new Lovely.List([0, [1,2, [3, [4]]]])
      result = list.flatten()

      assert.instanceOf result, Lovely.List
      assert.notSame    result, list
      assert.deepEqual  result.toArray(), [0,1,2,3,4]


  describe "#merge(list)", ->
    it "should merge another arrays in the current one", ->
      array  = [1,2]
      result = array.merge([3,4])

      assert.deepEqual result, [1,2,3,4]
      assert.same      result, array

    it "should skip items that are already on the list", ->
      assert.deepEqual [1,2,3].merge([2,3,4]), [1,2,3,4]


  describe "#uniq()", ->
    it "should return an array of uniq items on the list", ->
      array  = [1,1,2,3,3,2,1]
      result = array.uniq()

      assert.deepEqual result, [1,2,3]
      assert.notSame   result, array

    it "should work with Lovely.List instances", ->
      list   = new Lovely.List([1,1,2,3,3,2,1])
      result = list.uniq()

      assert.instanceOf result, Lovely.List
      assert.deepEqual  result.toArray(), [1,2,3]
      assert.notSame    result, list


  describe "#shuffle()", ->
    it "should create a shuffled version of the array", ->
      array  = [1,2,3,4,5]
      result = array.shuffle()

      assert.notSame      result, array
      assert.equal        result.length, array.length
      assert.notDeepEqual result, array

      for item in result
        assert.includes array, item

    it "should work with Lovely.List instances", ->
      list   = new Lovely.List([1,2,3,4,5])
      result = list.shuffle()

      assert.instanceOf   result, Lovely.List
      assert.notSame      result, list
      assert.equal        result.length,    list.length
      assert.notDeepEqual result.toArray(), list.toArray()

      for item in result
        assert.includes list.toArray(), item


  describe "#sort()", ->
    it "should sort strings as strings", ->
      array  = ['b', 'a', 'c']
      result = array.sort()

      assert.same      result, array
      assert.deepEqual result, ['a', 'b', 'c']

    it "should sort numbers as numbers", ->
      array   = [3,4,1,2]
      result  = array.sort()

      assert.same      result, array
      assert.deepEqual result, [1,2,3,4]

  describe "#min()", ->
    it "should return the minimal number on the list", ->
      assert.equal [1,2,3].min(), 1

  describe "#max()", ->
    it "should return the maximal number on the list", ->
      assert.equal [1,2,3].max(), 3

  describe "#sum()", ->
    it "should return the sum of all numbers on the list", ->
      assert.equal [1,2,3].sum(), 6