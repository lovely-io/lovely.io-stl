#
# The `Document` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('../../../../cli/lovely')


describe "Document", ->

  get = (callback)->
    Test.load module, ($, window)->
      callback(new $.Document(window.document), $, window)

  describe "\b#constructor", ->

    it "should create an instance of 'Document'", get (document, $, window)->
      document.should.be.instanceOf $.Document

    it "should refer to the raw dom-document via the '_' property", get (document, $, window)->
      document._.should.equal window.document

  describe 'events handling interface', ->

    it "should copy #no from Element#no", get (document, $)->
      ($.Document::no is $.Element::no).should.be.true

    it "should copy #ones from Element#ones", get (document, $)->
      ($.Document::ones is $.Element::ones).should.be.true

    it "should copy #emit from Element#emit", get (document, $)->
      ($.Document::emit is $.Element::emit).should.be.true

  describe 'DOM navigation interface', ->

    it "should use the same #find method as the Element", get (document, $)->
      ($.Document::find is $.Element::find).should.be.true

    it "should use the same #first method as the Element", get (document, $)->
      ($.Document::first is $.Element::first).should.be.true

  describe "\b#window()", ->

    it "should return the owner window wrapper", get (document, $, dom_window)->
      window = document.window()

      window.should.be.instanceOf $.Window
      window._.should.be.equal dom_window

    it "should return the same wrapper all the time", get (document)->
      document.window().should.equal document.window()

