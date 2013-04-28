#
# The UI.Options module tests
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

describe 'UI.Options', ->
  UI = Element = element = window = document = $ = Widget = widget = null

  before Test.load (build, win)->
    UI       = build
    window   = win
    document = win.document
    $        = win.Lovely.module('dom')
    Element  = $.Element

    Widget   = Element.inherit
      include: UI.Options
      extend:
        Options:
          stuff: 'something'
          other: 'stuff'
          somth: 'something'
          nested:
            value1: 'value1'
            value2: 'value2'

      constructor: (element, options)->
        options = @setOptions(options, 'widget', element)
        @$super element, options

    element  = document.createElement('div')
    element.setAttribute('data-widget-stuff', 'new stuff')

    widget   = new Widget(element, id: 'some-id', other: 'changed', nested: value1: 'new value')


  it "should set the 'options' property", ->
    widget.options.should.be.a 'object'

  it "should bypass the Element#constructor options", ->
    widget._.id.should.equal 'some-id'

  it "should not bypass Element#constructor options into the @options", ->
    (widget.options.id is undefined).should.be.true

  it "should assign the unchanged global options", ->
    widget.options.somth.should.equal 'something'

  it "should overwrite options from the hash specified in the constructor", ->
    widget.options.other.should.equal 'changed'

  it "should read the 'data-widget' attributes from the element", ->
    widget.options.stuff.should.equal 'new stuff'

  it "should merge nested properties correctly", ->
    widget.options.nested.value1.should.equal 'new value'
    widget.options.nested.value2.should.equal 'value2'

