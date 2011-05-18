#
# The 'Options' mixin unit-tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, Lovely} = require('../test_helper')

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


describe 'Options', module,
  'simple case':

    'should use defaults without options': ->
      assert.deepEqual new Simple().options,
        one: 'thing', another: 'one'

    'should overwrite defaults with custom options': ->
      assert.deepEqual new Simple(one: 'new').options,
        one: 'new', another: 'one'


  'with inheritance':

    'should find the defaults in super classes': ->
      assert.deepEqual new SubSimple(one: 'new').options,
        one: 'new', another: 'one'

  'nested options':

    'should deep-merge nested options': ->
      assert.deepEqual new Deep(one: 'new', another: one: 3).options,
        one: 'new', another: one: 3, two: 2
