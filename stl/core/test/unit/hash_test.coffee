#
# The `Hash` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, Lovely} = require('../test_helper')

Hash = Lovely.Hash

#
# A dummy class to check the prototype
# values filtration
#
# @param {Object} own properties
# @return undefined
#
Foo = (object) ->
  object or= {}
  for key, value of object
    this[key] = value
  this

Foo.prototype.boo = 'boo'
Foo.prototype.hoo = 'hoo'


describe 'Hash', module,
  '#initialization':
    topic: ->
      this.object = {}
      new Hash(this.object)

    "should create an instance of Hash": (hash) ->
      assert.instanceOf hash, Hash

    "should refer to the original object via the '_' attribute": (hash) ->
      assert.same hash._, this.object

  '#keys()':
    "should return an array of the keys": ->
      assert.deepEqual new Hash(a: 1, b: 2).keys(), ['a', 'b']

    "should skip prototype keys": ->
      assert.deepEqual new Hash(new Foo(a: 1, b: 2)).keys(), ['a', 'b']

  '#values()':
    "should return an array of values": ->
      assert.deepEqual new Hash(a: 1, b: 2).values(), [1, 2]

    "should skip any prototype values": ->
      assert.deepEqual new Hash(new Foo(a: 1, b: 2)).values(), [1, 2]

  '#empty()':
    "should say 'true' for empty hashes": ->
      assert.isTrue new Hash({}).empty()

    "should say 'false' for non empty hashes": ->
      assert.isFalse new Hash(a: 1).empty()

    "should filter out prototype properties": ->
      assert.isTrue  new Hash(new Foo()).empty()
      assert.isFalse new Hash(new Foo(a: 1)).empty()

  '#clone()':
    topic: {a:1, b:2}

    "should create a new Hash with cloned data": (data) ->
      original = new Hash(data)
      clone    = original.clone()

      assert.instanceOf clone, Hash
      assert.notSame    clone, original

      assert.deepEqual  clone._, data
      assert.notSame    clone._, data

    "should skip any prototype data": (data) ->
      original = new Hash(new Foo(data))
      clone    = original.clone()

      assert.instanceOf clone, Hash
      assert.notSame    clone, original

      assert.deepEqual  clone._, data
      assert.notSame    clone._, data

  '#forEach(callback)':
    "should go through every key-value pair": (result) ->
      hash   = new Hash(a:1, b:2)
      result = []

      ret = hash.forEach (key, value, hash) ->
        result.push([key, value, hash])

      assert.same      ret, hash
      assert.deepEqual result, [
        ['a', 1, {a:1, b:2}],
        ['b', 2, {a:1, b:2}]
      ]

    "should skip the prototype keys and values": ->
      result = []

      new Hash(new Foo(a:1, b:2)).forEach (key, value) ->
        result.push([key, value])

      assert.deepEqual result, [['a', 1], ['b', 2]]


  '#map(callback)':
    "should map result of key-value calls on the callback": ->
      hash = a:1, b:2

      result = new Hash(hash).map (key, value, hash) ->
        [key, value, hash]

      assert.deepEqual result, [
        ['a', 1, hash], ['b', 2, hash]
      ]

    "should skip prototype key-value pairs": ->
      data   = a: 1, b:2
      result = new Hash(new Foo(data)).map (key, value, hash) ->
        [key, value, hash]

      assert.deepEqual result, [
        ['a', 1, data], ['b', 2, data]
      ]

  '#filter(callback)':
    topic: ->
      this.original = new Hash(a:1, b:2, c:3)
      this.original.filter (key, value) ->
        key is 'a' || key is 'c'

    "should create a new Hash object": (hash) ->
      assert.instanceOf hash, Hash
      assert.notSame    hash, this.original

    "should filter the related object": (hash) ->
      assert.deepEqual hash._, {a:1, c:3}


  '#reject(callback)':
    topic: ->
      this.original = new Hash(a:1, b:2, c:3)
      this.original.reject (key, value) ->
        key is 'a' || key is 'c'

    "should create a new Hash object": (hash) ->
      assert.instanceOf hash, Hash
      assert.notSame    hash, this.original

    "should filter the related object": (hash) ->
      assert.deepEqual hash._, {b:2}


  '#merge(o1, o2,..)':
    topic: ->
      this.original = new Hash(a:3)
      this.original.merge(
        {a:1, b:3},
        new Foo(b:2, c:4), # checking prototypes filtering
        new Hash(c:3)      # checking Hashes processing
      )

    "should create a new Hash object": (hash) ->
      assert.instanceOf hash, Hash
      assert.notSame    hash, this.original

    "should merge the objects": (hash) ->
      assert.deepEqual hash._, {a:1, b:2, c:3}


  '#merge(o1, o2, ..) - deep':
    topic: ->
      this.o1 = {a: {b: {c: 'd'}, e: 'f'}}
      this.o2 = {a: {b: {c: 'd', e: 'f'}}}

      new Hash({}).merge(this.o1, this.o2)

    "should perform a deep merge of the data": (hash) ->
      assert.deepEqual hash._, {a: {b: {c: 'd', e: 'f'}, e: 'f'}}

    "should delink the keys": (hash) ->
      o  = hash._
      o1 = this.o1
      o2 = this.o2

      assert.isTrue(
        o.a isnt o1.a and o.a isnt o2.a and o.a.b isnt o1.a.b && o.a.b isnt o2.a.b
      )


  '.keys':
    "should return keys of an object": ->
      assert.deepEqual ['a', 'b'], Hash.keys(a:1, b:2)

  '.values':
    "should return values of an object": ->
      assert.deepEqual [1,2], Hash.values(a: 1, b:2)

  '.empty':
    "should check if an object is empty": ->
      assert.isTrue  Hash.empty({})
      assert.isFalse Hash.empty(a: 1)

  ".clone":
    "should clone an object": ->
      object = a: 1
      clone  = Hash.clone(object)

      assert.deepEqual clone, object
      assert.notSame   clone, object

  ".forEach":
    topic: ->
      this.args = []
      this.obj  = a: 1, b: 2
      Hash.forEach this.obj, (key, value, object) ->
        this.args.push([key, value, object])
      , this

    "should run through every key-value pair in the object": ->
      assert.deepEqual this.args, [
        ['a', 1, this.obj], ['b', 2, this.obj]
      ]

    "should return the object itself back": (result) ->
      assert.same result, this.obj

  ".map":
    "should map the results of callbacks on every key-value pairs": ->
      result = Hash.map {a: 1, b: 2}, (key, value) ->
        key + "-" + value

      assert.deepEqual result, ["a-1", "b-2"]

  ".filter":
    "should create a filtered object": ->
      hash = a: 1, b: 2, c: 3
      data = Hash.filter hash, (key, value) -> value % 2

      assert.notSame   data, hash
      assert.deepEqual data, {a:1, c:3}

  ".reject":
    "should create a new object without rejected pairs": ->
      hash = a: 1, b: 2, c: 3
      data = Hash.reject hash, (key, value) -> value % 2

      assert.notSame   data, hash
      assert.deepEqual data, {b:2}

  ".merge":
    "should merge objects and hashes and make a new object": ->
      object = a:1, b:3
      result = Hash.merge object,
        new Foo(b:2, c:4), # checking prototypes filtering
        new Hash(c:3)      # checking Hashes processing

      assert.notSame   result, object
      assert.deepEqual result, {a: 1, b: 2, c: 3}
