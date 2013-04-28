#
# Project's main unit test
#
# Copyright (C) 2012 Nikolay Nemshilov
#
{Test, assert} = require('lovely')

describe "Autocompleter", ->
  Autocompleter = window = document = input = $ = UI = autocompleter = null

  before Test.load (build, win)->
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

  it "should auto-initialize inputs with data-autocompleter attributes", ->
    i = new $.Input().data('autocompleter', '{}')
    i.insertTo(document.body)
    i.focus()
    i.autocompleter.should.be.instanceOf Autocompleter


  describe "#constructor", ->

    it "should build instances of Autocompleter", ->
      autocompleter.should.be.instanceOf Autocompleter

    it "should assign the input field as a reference", ->
      autocompleter.input.should.be.instanceOf $.Input
      autocompleter.input._.should.be.equal    input

    it "should make a reference for the autocompleter in the input wrapper", ->
      autocompleter.input.autocompleter.should.equal autocompleter

    it "should build a spinner widget", ->
      autocompleter.spinner.should.be.instanceOf UI.Spinner

    it "should set default options", ->
      autocompleter.options.should.be.a('object')
      autocompleter.options.src.should.equal Autocompleter.Options.src

    it "should read data-autocompleter options from the input element", ->
      i = document.createElement('input')
      i.setAttribute('data-autocompleter-src', 'some.url')
      a = new Autocompleter(i)
      a.options.src.should.equal 'some.url'


  describe "#update", ->

    it "should update the list with new items by a list of stuff", ->
      autocompleter.update(['one', 'two', 'three'], 'something')
      autocompleter.html().should.eql """
      <a href="#">one</a>
      <a href="#">two</a>
      <a href="#">three</a>
      """

    it "should highlight matching substrings and ignore cases", ->
      autocompleter.update(['Java', 'JavaScript', 'Ruby'], 'jav')
      autocompleter.html().should.eql """
      <a href="#"><strong>Jav</strong>a</a>
      <a href="#"><strong>Jav</strong>aScript</a>
      <a href="#">Ruby</a>
      """

    it "should still work with string content", ->
      autocompleter.update('bla bla bla')
      autocompleter.html().should.eql 'bla bla bla'

    it "should return the autocompleter object back", ->
      autocompleter.update(['stuff'], 'asdf').should.equal autocompleter
