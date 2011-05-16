#
# The `Document` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../test_helper'

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

    "should copy #on from Element#on": (window)->
      assert.same this.Document.prototype.on, this.Element.prototype.on

    "should copy #no from Element#no": (window)->
      assert.same this.Document.prototype.no, this.Element.prototype.no

    "should copy #ones from Element#ones": (window)->
      assert.same this.Document.prototype.ones, this.Element.prototype.ones

    "should copy #emit from Element#emit": (window)->
      assert.same this.Document.prototype.emit, this.Element.prototype.emit

  "#window()":
    topic: document

    "should return the owner window wrapper": (document)->
      window = document.window()

      assert.instanceOf window, this.Window
      assert.same       window._, this.window

    "should return the same wrapper all the time": (document)->
      assert.same document.window(), document.window()