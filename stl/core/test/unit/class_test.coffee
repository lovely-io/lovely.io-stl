#
# The `Class` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, Lovely} = require('../test_helper')

Class = Lovely.Class

describe 'Class', module,

  "new Class({..})":
    topic: -> new Class
      getName:        -> return this.name
      setName: (name) -> this.name = name

    'should be typeof a Function': (Klass) ->
      assert.isFunction Klass

    'should have those methods in its prototype': (Klass) ->
      assert.isFunction Klass.prototype.getName
      assert.isFunction Klass.prototype.setName

    'should refer to the class with prototype.constructor': (Klass) ->
      assert.same Klass.prototype.constructor, Klass

    'should not have anything besides those names': (Klass) ->
      assert.deepEqual(
        key for key of Klass.prototype,
        ['getName', 'setName']
      )

    'should allow to make instances of it': (Klass) ->
      assert.instanceOf new Klass(), Klass

    'should have those methods working': (Klass) ->
      klass = new Klass()
      klass.setName 'boo-hoo'
      assert.equal 'boo-hoo', klass.getName()



  'new Class({initialize: ...})':
    topic: -> new Class
      constructor: (a, b) ->
        this.name = a + '-' + b
        this

    'should call the constructor on the instance': (Klass) ->
      assert.equal 'boo-hoo', new Klass('boo', 'hoo').name

    "should return the constructor's result if sent": ->
      Klass = new Class constructor: -> ['some-other-data']

      assert.deepEqual new Klass(), ['some-other-data']


  'new Class() with a multilevel constructor inheritance':
    topic: ->
      this.Klass0 = new Class
        constructor: -> this.property = 'value'
      this.Klass1 = new Class this.Klass0,
        method1: 'method1'
      this.Klass2 = new Class this.Klass1,
        method2: 'method2'
      this.Klass3 = new Class this.Klass2,
        method3: 'method3'


    "should handle the first level inheritance": ->
      klass = new this.Klass1()

      assert.instanceOf klass, this.Klass1
      assert.instanceOf klass, this.Klass0
      assert.equal      klass.property, 'value'
      assert.equal      klass.method1,  'method1'


    "should handle the second level inheritance": ->
      klass = new this.Klass2()

      assert.instanceOf klass, this.Klass2
      assert.instanceOf klass, this.Klass1
      assert.instanceOf klass, this.Klass0
      assert.equal      klass.property, 'value'
      assert.equal      klass.method1,  'method1'
      assert.equal      klass.method2,  'method2'


    "should handle the third level inheritance": ->
      klass = new this.Klass3()

      assert.instanceOf klass, this.Klass3
      assert.instanceOf klass, this.Klass2
      assert.instanceOf klass, this.Klass1
      assert.instanceOf klass, this.Klass0
      assert.equal      klass.property, 'value'
      assert.equal      klass.method1,  'method1'
      assert.equal      klass.method2,  'method2'
      assert.equal      klass.method3,  'method3'



  'new Class':
    topic: ->
      this.ParentKlass = new Class
        constructor: -> this.prop = this.method(); this
        method: (data) -> data || 'parent'

    '\b(Parent)':
      topic: (Parent) -> new Class(Parent)

      "should refer '.__super__' to the parent class": (Klass) ->
        assert.same Klass.__super__, this.ParentKlass

      "should keep the parent's 'method'": (Klass) ->
        assert.same Klass.prototype.method, this.ParentKlass.prototype.method


    '\b(Parent, {...})':
      topic: (Parent) ->
        new Class Parent, method: -> 'child'

      "should refer '.__super__' to the parent class": (Klass) ->
        assert.same Klass.__super__, this.ParentKlass

      "should replace the parent class method": (Klass) ->
        assert.notEqual Klass.prototype.method, this.ParentKlass.prototype.method

      "should inherit the parent's class type": (Klass) ->
        klass = new Klass()

        assert.instanceOf klass, Klass
        assert.instanceOf klass, this.ParentKlass

      "should call this class methods": (Klass) ->
        assert.equal new Klass().method(), 'child'


    '\b(Parent, {...}) and $super calls':
      topic: (Parent) ->
        new Class Parent,
          method: -> this.$super('parent-data + ') + 'child-data'

      "should preform a proper super-call": (Klass) ->
        assert.equal new Klass().method(), 'parent-data + child-data'

    '\b(Parent, {constructor: ->})':
      topic: (Parent) ->
        new Class Parent,
          constructor: ->
            this.prop = this.$super().prop + ' + constructor'
            this

          method: ->
            this.$super() + ' + child'

      "should still refer the constructor to the correct class": (Klass) ->
        assert.same Klass.prototype.constructor, Klass

      "should correctly refer the __super__ property": (Klass) ->
        assert.same Klass.__super__, this.ParentKlass

      "should call everything in correct scopes": (Klass) ->
        klass = new Klass()
        assert.equal klass.prop, 'parent + child + constructor'



  'new Class() with shared modules':
    topic: ->
      this.ext = a: -> b: ->
      this.inc = c: -> d: ->

      return new Class
        include: this.inc
        extend:  this.ext

    "should extend the class-level with the 'extend' module": (Klass) ->
      assert.same Klass.a, this.ext.a
      assert.same Klass.b, this.ext.b

      assert.isFalse 'c' of Klass
      assert.isFalse 'd' of Klass

    "should extend the prototype with the 'include' module": (Klass) ->
      assert.same Klass.prototype.c, this.inc.c
      assert.same Klass.prototype.d, this.inc.d

      assert.isFalse 'a' of Klass.prototype
      assert.isFalse 'b' of Klass.prototype

  "in class methods overloading":
    topic: ->
      Klass = new Class
        method: -> "original"

      Klass.include
        method: -> this.$super() + "+overload"

    "should overload the method right in the class": (Klass)->
      assert.equal new Klass().method(), "original+overload"

