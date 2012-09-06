#
# The {List} unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('../../../../cli/lovely')

eval(Test.build(module))
Lovely = this.Lovely


describe "List", ->

  List  = Lovely.List
  array = [1,2,3,4,5]
  olist = new List(array)
  A     = Lovely.A

  # just a dummy class to test calls-by-name
  Foo = new Lovely.Class
    value:      null
    constructor: (v) -> @value = v
    getValue:    ( ) -> @value
    addValue:    (v) -> @value += v
    even:        ( ) -> @value % 2 is 0
    biggerThan:  (v) -> @value > v


  # making a list of Foo stuff to test various things
  FooList = new Lovely.Class List,
    constructor: (args)->
      @$super(args || [
        new Foo(1)
        new Foo(2)
        new Foo(3)
        new Foo(4)
      ])


  describe '\b#constructor', ->
    it 'should copy the array into itself', ->
      A(olist).should.eql array

    it "should make an instance of 'List'", ->
      olist.should.be.instanceOf List


  describe '\b#forEach(callback)', ->
    items   = []
    indexes = []
    result  = olist.forEach (item, index) ->
      items.push(item)
      indexes.push(index)

    it 'should get through all the items on the list', ->
      items.should.eql [1,2,3,4,5]

    it 'should send the index into the callback', ->
      indexes.should.eql [0,1,2,3,4]

    it 'should return the list object back', ->
      result.should.equal olist


  describe '\b#forEach("name", "arg")', ->
    list = new FooList().forEach("addValue", 2)

    it 'should add 2 to every value on the list', ->
      list.should.be.instanceOf FooList
      list.should.be.instanceOf List
      A(list.map((i) -> i.value)).should.eql [3,4,5,6]


  describe '\b#map(callback)', ->
    list = olist.map (item) -> item * 2

    it 'should make a new list', ->
      list.should.be.instanceOf List
      list.should.not.equal olist

    it 'should pack all the mapping results', ->
      A(list).should.eql [2,4,6,8,10]

  describe '\b#map("attr_name")', ->
    list = new FooList().map("value")

    it "should map the 'value' properties of the list", ->
      list.should.be.instanceOf List
      A(list).should.eql [1,2,3,4]

  describe '\b#map("method_name")', ->
    list = new FooList().map('getValue')

    it "should map the results of the 'getValue()' calls on the list the list", ->
      list.should.be.instanceOf List
      A(list).should.eql [1,2,3,4]

  describe '\b#map("method_name", "argument")', ->
    list = new FooList().map('addValue', 3)

    it "should map the results of the 'addValue(3)' method calls", ->
      list.should.be.instanceOf List
      A(list).should.eql [4,5,6,7]

  describe '\b#map("method_name", "arg1", "arg2")', ->
    list = new List(['boo', 'hoo']).map('replace', 'oo', 'aa')

    it "should map the result of calls", ->
      list.should.be.instanceOf List
      A(list).should.eql ['baa', 'haa']


  describe '\b#filter(callback)', ->
    list = olist.filter (item) -> item % 2

    it 'should create a new List', ->
      list.should.be.instanceOf List
      list.should.not.equal olist

    it 'should pack it with filtered data', ->
      A(list).should.eql [1,3,5]

  describe '\b#filter("method_name")', ->
    list = new FooList().filter('even')

    it "should filter the list by the method name calls", ->
      list.should.be.instanceOf List
      A(list.map('value')).should.eql [2,4]


  describe '\b#reject(callback)', ->
    list = olist.reject (item) -> item % 2

    it 'should create a new List', ->
      list.should.be.instanceOf List
      list.should.not.equal olist

    it 'should filter out all matching elements', ->
      A(list).should.eql [2,4]

  describe '\b#reject("method_name")', ->
    list = new FooList().reject("even")

    it "should reject values based on the name call", ->
      list.should.be.instanceOf FooList
      list.should.be.instanceOf List
      A(list.map('value')).should.eql [1,3]


  describe '\b#some(callback)', ->
    it "should return 'true' when some of the items match", ->
      (olist.some (item)-> item > 2).should.be.true

    it "should return 'false' when none of the items match", ->
      (olist.some (item)-> item > Infinity).should.be.false

  describe '\b#some("method_name")', ->
    list = new FooList()

    it "should return 'true' when some the items match", ->
      list.some("biggerThan", 2).should.be.true

    it "should return 'false' when none of the items match", ->
      list.some("biggerThan", Infinity).should.be.false


  describe '\b#every(callback)', ->
    it "should return 'true' when every item match", ->
      (olist.every (item)-> item > -1).should.be.true

    it "should return 'false' when some of the items don't match", ->
      (olist.every (item)-> item > 2).should.be.false

  describe '\b#every("method_name")', ->
    list = new FooList()

    it "should return 'true' when every item match", ->
      list.every("biggerThan", -1).should.be.true

    it "should return 'false' when some of items don't match", ->
      list.every("biggerThan", 2).should.be.false


  describe '\b#toArray()', ->
    array = olist.toArray()

    it 'should make an array out of the list', ->
      array.should.be.instanceOf Array
      array.should.not.be.instanceOf List

    it 'should feed it with the original data', ->
      array.should.eql A(olist)

    it 'should make a clone of the list not refer it by a link', ->
      array.should.not.equal A(olist)

  describe '\b#indexOf', ->
    index = olist.indexOf(2)

    it 'should return left index for the item', ->
      index.should.eql array.indexOf(2)


  describe '\b#lastIndexOf', ->
    index = olist.lastIndexOf(2)

    it 'should return the right index for the item', ->
      index.should.eql array.lastIndexOf(2)

  describe '\b#push', ->
    list = new List([1,2,3])
    list.push(4)

    it 'should push the item into the list', ->
      A(list).should.eql [1,2,3,4]


  describe '\b#pop', ->
    list = new List([1,2,3,4])
    item = list.pop()

    it "should return the last item out of the list", ->
      item.should.equal 4

    it "should subtract the list", ->
      list.should.be.instanceOf List
      A(list).should.eql [1,2,3]


  describe '\b#shift', ->
    list = new List([1,2,3,4])
    item = list.shift()

    it 'should return the first item', ->
      item.should.eql 1

    it 'should subtract the list itself', ->
      A(list).should.eql [2,3,4]

  describe '\b#unshift', ->
    list = new List([2,3,4])
    list.unshift(1)

    it 'should unshift the item into the list', ->
      A(list).should.eql [1,2,3,4]

  describe '\b#slice', ->
    list = olist.slice(2)

    it 'should make a new list', ->
      list.should.be.instanceOf List
      list.should.not.equal olist

    it 'should slice the original list', ->
      A(list).should.eql [3,4,5]

  describe '\b#splice', ->
    list  = new List([1,2,3,4])
    items = list.splice(1,2,5,6,7)

    it "should return the extracted items", ->
      items.should.eql [2,3]

    it "should remove and insert items correctly", ->
      A(list).should.eql [1,5,6,7,4]

  describe '\b#reverse', ->
    list   = new List([1,2,3,4])
    result = list.reverse()

    it "should not create a new list", ->
      result.should.equal list

    it "should reverse it's entries order", ->
      A(list).should.eql [4,3,2,1]

  describe '\b#concat', ->
    list   = new List([1,2])
    result = list.concat([3,4])

    it "should create a new list", ->
      result.should.be.instanceOf List
      result.should.not.equal list

    it "should add the new values", ->
      A(result).should.eql [1,2,3,4]

  describe '\b#sort', ->
    list   = new List(['c', 'd', 'b', 'a'])
    result = list.sort()

    it "should return the same list back to the code", ->
      result.should.equal list

    it "should sort the list items", ->
      A(list).should.eql ['a', 'b', 'c', 'd']

  describe '\b#join', ->
    result = new List([1,2,3,4,5]).join('-')

    it "should join the list items using separator", ->
      result.should.eql '1-2-3-4-5'

  describe '\bsubclass', ->
    list = new FooList()

    it "should return the subclass instance with the #slice operation", ->
      list.slice(1,2).should.be.instanceOf FooList

    it "should return a List instance with the #map operation", ->
      list.map('getValue').should.be.instanceOf List

    it "should return the subclass instance with the #filter operation", ->
      list.filter('odd').should.be.instanceOf FooList

    it "should return the subclass instance with the #reject operation", ->
      list.reject('event').should.be.instanceOf FooList

    it "should return the subclass instance with the #concat operation", ->
      list.concat([1,2,3]).should.be.instanceOf FooList
