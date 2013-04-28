#
# The `Document` unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')


describe "Document", ->
  $ = Document = window = document = null

  before Test.load (dom, win)->
    $        = dom
    window   = win
    Document = $.Document
    document = new Document(win.document)


  describe "\b#constructor", ->

    it "should create an instance of 'Document'", ->
      document.should.be.instanceOf Document

    it "should refer to the raw dom-document via the '_' property", ->
      document._.should.equal window.document

  describe 'events handling interface', ->

    it "should copy #no from Element#no", ->
      (Document::no is $.Element::no).should.be.true

    it "should copy #ones from Element#ones", ->
      (Document::ones is $.Element::ones).should.be.true

    it "should copy #emit from Element#emit", ->
      (Document::emit is $.Element::emit).should.be.true

  describe 'DOM navigation interface', ->

    it "should use the same #find method as the Element", ->
      (Document::find is $.Element::find).should.be.true

    it "should use the same #first method as the Element", ->
      (Document::first is $.Element::first).should.be.true

  describe "\b#window()", ->

    it "should return the owner window wrapper", ->
      win = document.window()

      win.should.be.instanceOf $.Window
      win._.should.be.equal    window

    it "should return the same wrapper all the time", ->
      document.window().should.equal document.window()

