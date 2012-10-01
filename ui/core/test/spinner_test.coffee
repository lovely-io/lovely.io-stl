#
# The spinner uint tests
#
# Copyright (C) 2012 Nikolay Nemshilov
#
{Test} = require('lovely')

describe "UI.Spinner", ->

  Spinner = spinner = null

  before Test.load module, (UI, window)->
    Spinner = UI.Spinner
    spinner = new Spinner()

  it "should build a Spinner instance", ->
    spinner.should.be.instanceOf Spinner

  it "should build a DIV element", ->
    spinner._.tagName.should.equal 'DIV'

  it "should build the correct number of divs inside", ->
    spinner.find('div').should.have.length spinner.options.size
    new Spinner(size: 22).find('div').should.have.length 22

  it "should assing the 'lui-spinner-current' class to one of the divs", ->
    spinner.find('div.lui-spinner-current').should.have.length 1

  it "should have 'circular' type by default", ->
    spinner.options.type.should.equal 'circular'

  it "should offer to rotate it by default", ->
    spinner.options.rotate.should.be.true