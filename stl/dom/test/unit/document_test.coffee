#
# The `Document` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, load} = require('../test_helper')

document = ->
  load "/test.html", this, (dom)->
    new dom.Document(this.document)

describe "Document", module,

  "constructor":
    topic: document

    "should create an instance of 'Document'": (document)->
      assert.instanceOf document, this.Document

    "should refer to the raw dom-document via the '_' property": (document)->
      assert.same document._, this.document

  'events handling interface':
    topic: document

    "should copy #no from Element#no": ->
      assert.same this.Document.prototype.no, this.Element.prototype.no

    "should copy #ones from Element#ones": ->
      assert.same this.Document.prototype.ones, this.Element.prototype.ones

    "should copy #emit from Element#emit": ->
      assert.same this.Document.prototype.emit, this.Element.prototype.emit

  'DOM navigation interface':
    topic: document

    "should use the same #find method as the Element": (document)->
      assert.same this.Document.prototype.find, this.Element.prototype.find

    "should use the same #first method as the Element": ->
      assert.same this.Document.prototype.first, this.Element.prototype.first

  "#window()":
    topic: document

    "should return the owner window wrapper": (document)->
      window = document.window()

      assert.instanceOf window, this.Window
      assert.same       window._, this.window

    "should return the same wrapper all the time": (document)->
      assert.same document.window(), document.window()