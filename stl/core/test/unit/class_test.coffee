#
# The `Class` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Lovely} = require('../test_helper')

Class = Lovely.Class

describe 'Class', ->

  describe "new Class({..})", ->
    Klass = new Class
      getName:        -> return this.name
      setName: (name) -> this.name = name

    it 'should be typeof a Function', ->
      Klass.should.be.a 'function'

    it 'should have those methods in its prototype', ->
      Klass.prototype.getName.should.be.a 'function'
      Klass.prototype.setName.should.be.a 'function'

    it 'should refer to the class with prototype.constructor', ->
      Klass.should.be.equal Klass.prototype.constructor

    it 'should not have anything besides those names', ->
      (key for key of Klass.prototype).should.eql ['getName', 'setName']

    it 'should allow to make instances of it', ->
      new Klass().should.be.instanceOf Klass

    it 'should have those methods working', ->
      klass = new Klass()
      klass.setName 'boo-hoo'
      klass.getName().should.eql 'boo-hoo'



  describe 'new Class({initialize: ...})', ->
    Klass = new Class
      constructor: (a, b) ->
        this.name = a + '-' + b
        this

    it 'should call the constructor on the instance', ->
      new Klass('boo', 'hoo').name.should.eql 'boo-hoo'

    "should return the constructor's result if sent": ->
      Klass = new Class constructor: -> ['some-other-data']

      new Klass().should.eql ['some-other-data']


  describe 'new Class() with a multilevel constructor inheritance', ->
    Klass0 = new Class
      constructor: -> this.property = 'value'
    Klass1 = new Class Klass0,
      method1: 'method1'
    Klass2 = new Class Klass1,
      method2: 'method2'
    Klass3 = new Class Klass2,
      method3: 'method3'


    it "should handle the first level inheritance", ->
      klass = new Klass1()

      klass.should.be.instanceOf Klass1
      klass.should.be.instanceOf Klass0
      klass.property.should.eql 'value'
      klass.method1.should.eql  'method1'


    it "should handle the second level inheritance", ->
      klass = new Klass2()

      klass.should.be.instanceOf Klass2
      klass.should.be.instanceOf Klass1
      klass.should.be.instanceOf Klass0
      klass.property.should.eql 'value'
      klass.method1.should.eql  'method1'
      klass.method2.should.eql  'method2'


    it "should handle the third level inheritance", ->
      klass = new Klass3()

      klass.should.be.instanceOf Klass3
      klass.should.be.instanceOf Klass2
      klass.should.be.instanceOf Klass1
      klass.should.be.instanceOf Klass0
      klass.property.should.eql 'value'
      klass.method1.should.eql  'method1'
      klass.method2.should.eql  'method2'
      klass.method3.should.eql  'method3'



  describe 'new Class', ->
    ParentKlass = new Class
      constructor: -> this.prop = this.method(); this
      method: (data) -> data || 'parent'

    describe '\b(Parent)', ->
      Klass = new Class(ParentKlass)

      it "should refer '.__super__' to the parent class", ->
        Klass.__super__.should.equal ParentKlass

      it "should keep the parent's 'method'", ->
        Klass.prototype.method.should.equal ParentKlass.prototype.method


    describe '\b(Parent, {...})', ->
      Klass = new Class ParentKlass, method: -> 'child'

      it "should refer '.__super__' to the parent class", ->
        Klass.__super__.should.be.equal ParentKlass

      it "should replace the parent class method", ->
        Klass.prototype.method.should.not.equal ParentKlass.prototype.method

      it "should inherit the parent's class type", ->
        klass = new Klass()

        klass.should.be.instanceOf Klass
        klass.should.be.instanceOf ParentKlass

      it "should call this class methods", ->
        new Klass().method().should.eql 'child'


    describe '\b(Parent, {...}) and $super calls', ->
      Klass = new Class ParentKlass,
        method: -> this.$super('parent-data + ') + 'child-data'

      it "should preform a proper super-call", ->
        new Klass().method().should.eql 'parent-data + child-data'

    describe '\b(Parent, {constructor: ->})', ->
      Klass = new Class ParentKlass,
        constructor: ->
          this.prop = this.$super().prop + ' + constructor'
          this

        method: ->
          this.$super() + ' + child'

      it "should still refer the constructor to the correct class", ->
        Klass.prototype.constructor.should.be.equal Klass

      it "should correctly refer the __super__ property", ->
        Klass.__super__.should.be.equal ParentKlass

      it "should call everything in correct scopes", ->
        klass = new Klass()
        klass.prop.should.eql 'parent + child + constructor'



  describe 'new Class() with shared modules', ->
    ext = a: [], b: []
    inc = c: [], d: []

    Klass = new Class
      include: inc
      extend:  ext

    it "should extend the class-level with the 'extend' module", ->
      Klass.a.should.be.same ext.a
      Klass.b.should.be.same ext.b

      Klass.should.not.have.keys(['c'])
      Klass.should.not.have.keys(['d'])

    it "should extend the prototype with the 'include' module", ->
      Klass.prototype.c.should.be.same inc.c
      Klass.prototype.d.should.be.same inc.d

      Klass.prototype.should.not.have.keys(['a'])
      Klass.prototype.should.not.have.keys(['b'])

  describe "in class methods overloading", ->
    Klass = new Class
      method: -> "original"

    Klass.include
      method: -> this.$super() + "+overload"

    it "should overload the method right in the class", ->
      new Klass().method().should.be.eql "original+overload"
