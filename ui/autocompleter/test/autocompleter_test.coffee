#
# Project's main unit test
#
# Copyright (C) 2012 Nikolay Nemshilov
#
{Test, assert} = require('lovely')

describe "Autocompleter", ->
  Autocompleter = window = document = input = $ = UI = autocompleter = null

  before Test.load module, (build, win)->
    Autocompleter = build
    $             = win.Lovely.module('dom')
    UI            = win.Lovely.module('ui')
    window        = win
    document      = win.document
    input         = document.createElement('input')
    autocompleter = new Autocompleter(input)

  it "should have a version", ->
    assert.ok Autocompleter.version

  it "should be a subclass of the UI.Menu", ->
    Autocompleter.__super__.should.equal UI.Menu


  describe "#constructor", ->

    it "should build instances of Autocompleter", ->
      autocompleter.should.be.instanceOf Autocompleter
