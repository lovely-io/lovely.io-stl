#
# The `$.Style` custom wrapper tests
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

describe 'Style', ->
  $ = Element = Style = null

  before Test.load (dom)->
    $ = dom; Element = $.Element; Style = $.Style

  it "should be registered as a dom-wrapper", ->
    $.Wrapper.get('style').should.equal Style

  it "should inherit the Element class", ->
    Style.__super__.should.equal Element

    style = new Style()

    style.should.be.instanceOf Style
    style.should.be.instanceOf Element

  it "should assign the type='text/css' attribute automatically", ->
    style = new Style()

    style._.getAttribute('type').should.eql 'text/css'

  it "should repurpose the 'html' option as the css text", ->
    style = new Style(html: "div {color: blue}")

    text  = style._.firstChild

    text.nodeType.should.eql  3
    text.nodeValue.should.eql "div {color: blue}"
