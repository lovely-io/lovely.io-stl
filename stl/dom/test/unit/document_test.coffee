#
# The `Document` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../test_helper'

load_document = ->
  load "/test.html", this, (dom)->
    new dom.Document(this.document)

describe "Document", module,

  "constructor":
    topic: load_document

    "should create an instance of 'Document'": (document)->
      assert.instanceOf document, this.Document

    "should refer to the raw dom-document via the '_' property": (document)->
      assert.same document._, this.document

  "#window()":
    topic: load_document

    "should return the owner window wrapper": (document)->
      window = document.window()

      assert.instanceOf window, this.Window
      assert.same       window._, this.window

    "should return the same wrapper all the time": (document)->
      assert.same document.window(), document.window()