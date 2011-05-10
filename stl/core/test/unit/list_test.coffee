#
# The {List} unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require('../test_helper')

List  = Lovely.List
array = [1,2,3,4,5]
list  = new List(array)

A     = Lovely.A

ensure_new_list = (object) ->
  assert.instanceOf object, List
  assert.notSame    object, list

assert.listEqual = (list, array) ->
  assert.instanceOf list, List
  assert.deepEqual  A(list), A(array)

# just a dummy class to test calls-by-name
Foo = new Lovely.Class
  value:      null
  initialize: (v) -> this.value = v
  getValue:   ( ) -> this.value
  addValue:   (v) -> this.value += v
  even:       ( ) -> this.value % 2 is 0


# making a list of Foo stuff to test various things
FooList = new Lovely.Class List,
  initialize: ->
    this.$super([
      new Foo(1)
      new Foo(2)
      new Foo(3)
      new Foo(4)
    ])


describe "List", module,

  'constructor':
    topic: list

    'should copy the array into itself': (list) ->
      assert.listEqual list, array

    "should make an instance of 'List'": (list) ->
      assert.instanceOf list, List

    "should inherit the Array": (list) ->
      assert.instanceOf list, Array


  '#first':
    '\b()':
      topic: list.first()

      'should return the first item on the list': (item) ->
        assert.same item, list[0]

    '\b(callback)':
      topic: -> list.first (item) -> item % 2 == 0

      'should return the first item that match the callback': (item) ->
        assert.same item, 2


  '#last':
    '\b()':
      topic: list.last()

      'should return the last item on the list': (item) ->
        assert.same item, list[list.length - 1]

    '\b(callback)':
      topic: -> list.last (item) -> item % 2 == 0

      'should return the last matching item': (item) ->
        assert.same item, 4


  '#size()':
    topic: list.size()

    'should return the list size': (size) ->
      assert.same size, list.length


  '#each(callback)':
    topic: ->
      this.items   = []
      this.indexes = []

      list.each (item, index) ->
        this.items.push(item)
        this.indexes.push(index)
      , this

    'should get through all the items on the list': (items) ->
      assert.deepEqual this.items, [1,2,3,4,5]

    'should send the index into the callback': (items) ->
      assert.deepEqual this.indexes, [0,1,2,3,4]

    'should return the list object back': (result) ->
      assert.same result, list


  '#each("name", "arg")':
    topic: new FooList().each("addValue", 2)

    'should add 2 to every value on the list': (list) ->
      assert.instanceOf list, FooList
      assert.listEqual  list.map((i) -> i.value), [3,4,5,6]


  '#map(callback)':
    topic: list.map (item) -> item * 2

    'should make a new list': ensure_new_list,

    'should pack all the mapping results': (list) ->
      assert.listEqual list, [2,4,6,8,10]

  '#map("attr_name")':
    topic: new FooList().map("value")

    "should map the 'value' properties of the list": (list) ->
      assert.listEqual list, [1,2,3,4]

  '#map("method_name")':
    topic: new FooList().map('getValue')

    "should map the results of the 'getValue()' calls on the list the list": (list) ->
      assert.listEqual list, [1,2,3,4]

  '#map("method_name", "argument")':
    topic: new FooList().map('addValue', 3)

    "should map the results of the 'addValue(3)' method calls": (list) ->
      assert.listEqual list, [4,5,6,7]

  '#map("method_name", "arg1", "arg2")':
    topic: new List(['boo', 'hoo']).map('replace', 'oo', 'aa')

    "should map the result of calls": (list) ->
      assert.listEqual list, ['baa', 'haa']


  '#filter(callback)':
    topic: list.filter (item) -> item % 2

    'should create a new List': ensure_new_list,

    'should pack it with filtered data': (list) ->
      assert.listEqual list, [1,3,5]

  '#filter("method_name")':
    topic: new FooList().filter('even')

    "should filter the list by the method name calls": (list) ->
      assert.listEqual list.map('value'), [2,4]


  '#reject(callback)':
    topic: list.reject (item) -> item % 2

    'should create a new List': ensure_new_list,

    'should filter out all matching elements': (list) ->
      assert.listEqual list, [2,4]

  '#reject("method_name")':
    topic: new FooList().reject("even")

    "should reject values based on the name call": (list) ->
      assert.listEqual list.map('value'), [1,3]

  '#without(a,b,c)': ->
    topic: list.without(1,2,4)

    'should create a new List': ensure_new_list

    'should filter out listed values': (list) ->
      assert.listEqual list, [3,5]

  '#compact()':
    topic: ->
      this.original = new List([null, '', undefined, 0, 1])
      this.original.compact()

    'should create a new List': (list) ->
      assert.instanceOf list, List
      assert.notSame    list, this.original

    'should filter out nulls and undefineds': (list) ->
      assert.listEqual list, ['', 0, 1]


  '#toArray()':
    topic: list.toArray()

    'should make an array out of the list': (array) ->
      assert.isArray array

    'should feed it with the original data': (array) ->
      assert.deepEqual array, A(list)

    'should make a clone of the list not refer it by a link': (array) ->
      assert.notSame array, A(list)


  '#clone()':
    topic: list.clone()

    'should make a new list': ensure_new_list

    'should clone the data': (result) ->
      assert.deepEqual A(result), A(list)
      assert.notSame   result, list


  '#indexOf':
    topic: list.indexOf(2)

    'should return left index for the item': (index) ->
      assert.equal index, array.indexOf(2)


  '#lastIndexOf':
    topic: list.lastIndexOf(2)

    'should return the right index for the item': (index) ->
      assert.equal index, array.lastIndexOf(2)

  '#push':
    topic: ->
      this.list = new List([1,2,3])
      this.list.push(4)
      this.list

    'should push the item into the list': (list) ->
      assert.listEqual list, [1,2,3,4]


  '#pop':
    topic: ->
      this.list = new List([1,2,3,4])
      this.list.pop()

    "should return the last item out of the list": (item) ->
      assert.equal item, 4

    "should subtract the list": ->
      assert.listEqual this.list, [1,2,3]


  '#shift':
    topic: ->
      this.list = new List([1,2,3,4])
      this.list.shift()

    'should return the first item': (item) ->
      assert.equal item, 1

    'should subtract the list itself': ->
      assert.listEqual this.list, [2,3,4]

  '#unshift':
    topic: ->
      this.list = new List([2,3,4])
      this.list.unshift(1)
      this.list

    'should unshift the item into the list': (list) ->
      assert.listEqual list, [1,2,3,4]

  '#slice':
    topic: list.slice(2)

    'should make a new list': ensure_new_list

    'should slice the original list': (list) ->
      assert.listEqual list, [3,4,5]
