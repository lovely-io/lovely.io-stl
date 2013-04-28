#
# The 'Options' mixin unit-tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

eval(Test.build(module))
Lovely = this.Lovely


describe 'Options', ->

  Class   = Lovely.Class
  Options = Lovely.Options


  # a simple options module usage
  Simple  = new Class
    include: Options
    extend:
      Options:
        one:     'thing'
        another: 'one'

    constructor: (options) ->
      this.setOptions options



  # a subclass options usage
  SubSimple = new Class Simple,
    constructor: (options) ->
      this.$super(options)



  # deep options merge check
  Deep = new Class
    include: Options
    extend:
      Options:
        one: 'thing'
        another:
          one: 1
          two: 2

    constructor: (options) ->
      this.setOptions options



  describe 'simple case', ->

    it 'should use defaults without options', ->
      new Simple().options.should.eql one: 'thing', another: 'one'

    it 'should overwrite defaults with custom options', ->
      new Simple(one: 'new').options.should.eql one: 'new', another: 'one'

    it "should not screw with the Lovely.Class instances", ->
      Klass = new Class()
      klass = new Klass()
      new Simple(one: klass).options.one.should.equal klass


  describe 'with inheritance', ->

    it 'should find the defaults in super classes', ->
      new SubSimple(one: 'new').options.should.eql one: 'new', another: 'one'

  describe 'nested options', ->

    it 'should deep-merge nested options', ->
      new Deep(one: 'new', another: one: 3).options.should.eql one: 'new', another: one: 3, two: 2
