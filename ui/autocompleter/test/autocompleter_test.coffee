#
# Project's main unit test
#
# Copyright (C) 2012 Nikolay Nemshilov
#
{Test, assert} = require('lovely')

describe "Autocompleter", ->
  Autocompleter = null

  before Test.load(module, (build)-> Autocompleter = build)

  it "should have a version", ->
    assert.ok Autocompleter.version

