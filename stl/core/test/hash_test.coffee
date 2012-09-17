#
# The `Hash` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

eval(Test.build(module))
Lovely = this.Lovely

describe 'Hash', ->
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


  describe '\b#constructor', ->
    hash = new Hash(object = {})

    it "should create an instance of Hash", ->
      hash.should.be.instanceOf Hash

    it "should refer to the original object via the '_' attribute", ->
      hash._.should.equal object

  describe '\b#keys()', ->
    it "should return an array of the keys", ->
      new Hash(a: 1, b: 2).keys().should.eql ['a', 'b']

    it "should skip prototype keys", ->
      new Hash(new Foo(a: 1, b: 2)).keys().should.eql ['a', 'b']

  describe '\b#values()', ->
    it "should return an array of values", ->
      new Hash(a: 1, b: 2).values().should.eql [1, 2]

    it "should skip any prototype values", ->
      new Hash(new Foo(a: 1, b: 2)).values().should.eql [1, 2]

  describe '\b#empty()', ->
    it "should say 'true' for empty hashes", ->
      new Hash({}).empty().should.be.true

    it "should say 'false' for non empty hashes", ->
      new Hash(a: 1).empty().should.be.false

    it "should filter out prototype properties", ->
      new Hash(new Foo()).empty().should.be.true
      new Hash(new Foo(a: 1)).empty().should.be.false

  describe '\b#clone()', ->
    data = {a:1, b:2}

    it "should create a new Hash with cloned data", ->
      original = new Hash(data)
      clone    = original.clone()

      clone.should.be.instanceOf Hash
      clone.should.not.equal original

      clone._.should.eql data
      clone._.should.not.equal data

    it "should skip any prototype data", ->
      original = new Hash(new Foo(data))
      clone    = original.clone()

      clone.should.be.instanceOf Hash
      clone.should.not.equal original

      clone._.should.eql data
      clone._.should.not.equal data

  describe '\b#forEach(callback)', ->
    it "should go through every key-value pair", ->
      hash   = new Hash(a:1, b:2)
      result = []

      ret = hash.forEach (key, value, hash) ->
        result.push([key, value, hash])

      ret.should.equal hash
      result.should.eql [
        ['a', 1, {a:1, b:2}],
        ['b', 2, {a:1, b:2}]
      ]

    it "should skip the prototype keys and values", ->
      result = []

      new Hash(new Foo(a:1, b:2)).forEach (key, value) ->
        result.push([key, value])

      result.should.eql [['a', 1], ['b', 2]]


  describe '\b#map(callback)', ->
    it "should map result of key-value calls on the callback", ->
      hash = a:1, b:2

      result = new Hash(hash).map (key, value, hash) ->
        [key, value, hash]

      result.should.eql [
        ['a', 1, hash], ['b', 2, hash]
      ]

    it "should skip prototype key-value pairs", ->
      data   = a: 1, b:2
      result = new Hash(new Foo(data)).map (key, value, hash) ->
        [key, value, hash]

      result.should.eql [
        ['a', 1, data], ['b', 2, data]
      ]

  describe '\b#filter(callback)', ->
    original = new Hash(a:1, b:2, c:3)
    hash = original.filter (key, value) ->
        key is 'a' || key is 'c'

    it "should create a new Hash object", ->
      hash.should.be.instanceOf Hash
      hash.should.not.equal original

    it "should filter the related object", ->
      hash._.should.eql {a:1, c:3}


  describe '\b#reject(callback)', ->
    original = new Hash(a:1, b:2, c:3)
    hash = original.reject (key, value) ->
        key is 'a' || key is 'c'

    it "should create a new Hash object", ->
      hash.should.be.instanceOf Hash
      hash.should.not.equal original

    it "should filter the related object", ->
      hash._.should.eql {b:2}


  describe '\b#merge(o1, o2,..)', ->
    original = new Hash(a:3)
    hash = original.merge(
      {a:1, b:3},
      new Foo(b:2, c:4), # checking prototypes filtering
      new Hash(c:3)      # checking Hashes processing
    )

    it "should create a new Hash object", ->
      hash.should.be.instanceOf Hash
      hash.should.not.equal original

    it "should merge the objects", ->
      hash._.should.eql {a:1, b:2, c:3}


  describe '\b#merge(o1, o2, ..) - deep -', ->
    o1 = {a: {b: {c: 'd'}, e: 'f'}}
    o2 = {a: {b: {c: 'd', e: 'f'}}}

    hash = new Hash({}).merge(o1, o2)

    it "should perform a deep merge of the data", ->
      hash._.should.eql {a: {b: {c: 'd', e: 'f'}, e: 'f'}}

    it "should delink the keys", ->
      o  = hash._

      (
        o.a isnt o1.a and o.a isnt o2.a and o.a.b isnt o1.a.b && o.a.b isnt o2.a.b
      ).should.be.true


  describe '\b.keys', ->
    it "should return keys of an object", ->
      Hash.keys(a:1, b:2).should.eql ['a', 'b']

  describe '\b.values', ->
    it "should return values of an object", ->
      Hash.values(a: 1, b:2).should.eql [1,2]

  describe '\b.empty', ->
    it "should check if an object is empty", ->
      Hash.empty({}).should.be.true
      Hash.empty(a: 1).should.be.false

  describe "\b.clone", ->
    it "should clone an object", ->
      object = a: 1
      clone  = Hash.clone(object)

      clone.should.eql       object
      clone.should.not.equal object

  describe "\b.forEach", ->
    args = []
    obj  = a: 1, b: 2
    hash = Hash.forEach obj, (key, value, object) ->
        args.push([key, value, object])

    it "should run through every key-value pair in the object", ->
      args.should.eql [
        ['a', 1, obj], ['b', 2, obj]
      ]

    it "should return the object itself back", ->
      hash.should.equal obj

  describe "\b.map", ->
    it "should map the results of callbacks on every key-value pairs", ->
      result = Hash.map {a: 1, b: 2}, (key, value) ->
        key + "-" + value

      result.should.eql ["a-1", "b-2"]

  describe "\b.filter", ->
    it "should create a filtered object", ->
      hash = a: 1, b: 2, c: 3
      data = Hash.filter hash, (key, value) -> value % 2

      data.should.not.equal hash
      data.should.eql {a:1, c:3}

  describe "\b.reject", ->
    it "should create a new object without rejected pairs", ->
      hash = a: 1, b: 2, c: 3
      data = Hash.reject hash, (key, value) -> value % 2

      data.should.not.equal hash
      data.should.eql {b:2}

  describe "\b.merge", ->
    it "should merge objects and hashes and make a new object", ->
      object = a:1, b:3
      result = Hash.merge object,
        new Foo(b:2, c:4), # checking prototypes filtering
        new Hash(c:3)      # checking Hashes processing

      result.should.not.equal object
      result.should.eql {a: 1, b: 2, c: 3}
