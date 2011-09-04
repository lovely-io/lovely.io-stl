#
# The `$` function unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, load} = require('../test_helper')

server.respond "/main.html": """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="test"></div>
    </body>
  </html>
"""

dom = ->
  load "/main.html", this, (d) -> d


describe '$', module,

  'css search':
    topic: dom

    'should find elements by a css-rule': ($)->
      result = $('#test')

      assert.isTrue result instanceof $.Search
      assert.equal  result.length, 1
      assert.equal  result[0].attr('id'), 'test'

    'should return an empty search when nothing found': ($)->
      result = $('#non-existing')

      assert.isTrue result instanceof $.Search
      assert.equal  result.length, 0

    # FIXME: the `window.window == window` hack doesn't work in jsdom
    #        need to figure out something else
    # 'window wrapping':
    #       topic: dom
    #
    #       'should return a window wrapper for a window': ($)->
    #         win = $(this.window)
    #
    #         assert.isTrue win instanceof $.Window
    #         assert.isTrue     win._ is this.window
    #
    #       'should return the same window wrapper back': ($)->
    #         win = $(this.window)
    #
    #         assert.isTrue $(win) is win

  'document wrapping':
    topic: dom

    'should wrap a document': ($)->
      doc = $(this.document)

      assert.isTrue doc instanceof $.Document
      assert.same   doc._, this.document

    'should return the same wrapper if already wrapped': ($)->
      doc = $(this.document)

      assert.same doc, $(doc)

  'element wrapping':
    topic: dom

    'should return a wrapper for a dom-element': ($)->
      div = this.document.getElementById('test')
      element = $(div)

      assert.isTrue element instanceof $.Element
      assert.same   element._, div

    'should return the same wrapper if an element is already wrapped': ($)->
      div = this.document.getElementById('test')
      element = $(div)

      assert.same element, $(element)