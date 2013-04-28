#
# The UI.Icon unit tests
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

describe "UI.Icon", ->
  UI = Icon = icon = Element = null

  before Test.load (build, window)->
    UI      = build
    Icon    = UI.Icon
    icon    = new Icon('name')
    Element = window.Lovely.module('dom').Element

  it "should make Icon instances", ->
    icon.should.be.instanceOf Icon
    icon._.tagName.should.equal "I"

  it "should be a subclass of the Element class", ->
    Icon.__super__.should.equal Element

  it "should assign the lui-icon-name class", ->
    icon._.className.should.equal 'lui-icon-name'

  it "should accept extra parameter with HTML options", ->
    i = new Icon('name', id: 'my-icon', class: 'some-icon')
    i._.id.should.equal 'my-icon'
    i._.className.should.equal 'some-icon lui-icon-name'
