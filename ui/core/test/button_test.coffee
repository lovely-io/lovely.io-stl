#
# The UI.Button unit tests
#
# Copyright (C) 2012 Nikolay Nemshilov
#
{Test} = require('lovely')

describe 'UI.Button', ->
  UI = Button = button = $ = null

  before Test.load module, (build, win)->
    UI     = build
    Button = UI.Button
    button = new Button('some text')
    $      = win.Lovely.module('dom')

  it "should build buttons", ->
    button.should.be.instanceOf Button
    button._.tagName.should.equal 'BUTTON'

  it "should inherit the Input class", ->
    button.should.be.instanceOf $.Input

  it "should have type of 'button'", ->
    button._.type.should.equal 'button'

  it "should assign the 'lui-button' class", ->
    button._.className.should.equal 'lui-button'

  it "should assign the button label as the HTML", ->
    button._.innerHTML.should.equal 'some text'

  it "should accept normal html options", ->
    b = new Button('new text', id: 'my-id', class: 'my-class')
    b._.id.should.equal 'my-id'
    b._.className.should.equal 'my-class lui-button'
    b._.innerHTML.should.equal 'new text'