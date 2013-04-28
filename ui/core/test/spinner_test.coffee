#
# The spinner uint tests
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

describe "UI.Spinner", ->

  Spinner = spinner = document = null

  before Test.load (UI, window)->
    Spinner  = UI.Spinner
    spinner  = new Spinner()
    document = window.document

  it "should build a Spinner instance", ->
    spinner.should.be.instanceOf Spinner

  it "should build a DIV element", ->
    spinner._.tagName.should.equal 'DIV'

  it "should assignt he 'lui-spinner' class", ->
    spinner.hasClass('lui-spinner').should.be.true

  it "should build the correct number of divs inside", ->
    spinner._.getElementsByTagName('div').should.have.length spinner.options.size
    new Spinner(size: 22)._.getElementsByTagName('div').should.have.length 22

  it "should accept extra HTML attributes", ->
    s = new Spinner(id: 'my-id', class: 'my-class')
    s.hasClass('lui-spinner').should.be.true
    s.hasClass('my-class').should.be.true
    s.attr('id').should.equal 'my-id'

  it "should assing the 'lui-spinner-current' class to one of the divs", ->
    spinner.find('div.lui-spinner-current').should.have.length 1

  it "should have 'circular' type by default", ->
    spinner.options.type.should.equal 'circular'

  it "should offer to rotate it by default", ->
    spinner.options.rotate.should.be.true

  it "should add the 'lui-spinner-circular' class for circular spinners", ->
    document.body.style.transform = 'rotate(0deg)'
    #new Spinner(type: 'circular').hasClass('lui-spinner-circular').should.be.true

  it "should not add the 'lui-spinner-circular' class to the flat spinenrs", ->
    new Spinner(type: 'flat').hasClass('lui-spinner-circular').should.be.false
