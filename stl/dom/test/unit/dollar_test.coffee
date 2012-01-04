#
# The `$` function unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, load} = require('../test_helper')

server.respond "/dollar.html": """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="one">
        <div class="one">#one .one</div>
        <div class="two">#one .two</div>
      </div>
      <div id="two">
        <div class="one">#two .one</div>
        <div class="two">#two .two</div>
      </div>
      <div id="three">
        <div class="one">#three .one</div>
        <div class="two">#three .two</div>
      </div>
    </body>
  </html>
"""

dom = ->
  load "/dollar.html", this, (d) -> d

describe '$', module,

  'css search':
    topic: dom

    "should correctly find elements by ID": ($)->
      search = $('#one')

      assert.instanceOf search,      this.NodeList
      assert.lengthOf   search,      1
      assert.instanceOf search[0],   this.Element
      assert.same       search[0]._, this.document.getElementById('one')


    "should correctly find elements by class name": ($)->
      search = $('.one')

      assert.instanceOf search,      this.NodeList
      assert.lengthOf   search,      3
      assert.instanceOf search[0],   this.Element
      assert.instanceOf search[1],   this.Element
      assert.instanceOf search[2],   this.Element
      assert.same       search[0]._, this.document.querySelector('#one   .one')
      assert.same       search[1]._, this.document.querySelector('#two   .one')
      assert.same       search[2]._, this.document.querySelector('#three .one')


    "should correctly find elements in a context": ($)->
      search = $('.one, .two', this.document.getElementById('one'))

      assert.instanceOf search,      this.NodeList
      assert.lengthOf   search,      2
      assert.same       search[0]._, this.document.querySelector('#one .one')
      assert.same       search[1]._, this.document.querySelector('#one .two')


    "should accept dom-wrappers as the context": ($)->
      element = $(this.document.getElementById('two'))
      search  = $('.one, .two', element)

      assert.instanceOf search,      this.NodeList
      assert.lengthOf   search,      2
      assert.same       search[0]._, this.document.querySelector('#two .one')
      assert.same       search[1]._, this.document.querySelector('#two .two')


    'should return an empty list when nothing found by id': ($)->
      result = $('#non-existing')

      assert.instanceOf result, this.NodeList
      assert.lengthOf   result, 0

    'should return an empty list when nothing was found by a css selector': ($)->
      result = $('div.non .existing')

      assert.instanceOf result, this.NodeList
      assert.lengthOf   result, 0


    'HTML to NodeList conversion':
      topic: dom

      "should create a node-list out of a piece of HTML": ($)->
        search = $('<span>one</span><b>two</b>')

        assert.instanceOf search,    this.NodeList
        assert.lengthOf   search,    2
        assert.instanceOf search[0], this.Element
        assert.instanceOf search[1], this.Element
        assert.equal      search[0]._.tagName, 'SPAN'
        assert.equal      search[1]._.tagName, 'B'
        assert.equal      search[0]._.innerHTML, 'one'
        assert.equal      search[1]._.innerHTML, 'two'


  'window wrapping':
    topic: dom

    'should return a window wrapper for a window': ($)->
      win = $(this.window)

      assert.isTrue win instanceof $.Window
      assert.isTrue     win._ is this.window

    'should return the same window wrapper back': ($)->
      win = $(this.window)

      assert.isTrue $(win) is win

  'document wrapping':
    topic: dom

    'should wrap a document': ($)->
      doc = $(this.document)

      assert.instanceOf doc,   this.Document
      assert.same       doc._, this.document

    'should return the same wrapper if already wrapped': ($)->
      doc = $(this.document)

      assert.same doc, $(doc)

  'element wrapping':
    topic: dom

    'should return a wrapper for a dom-element': ($)->
      div = this.document.getElementById('one')
      element = $(div)

      assert.instanceOf element,   this.Element
      assert.same       element._, div

    'should return the same wrapper if an element is already wrapped': ($)->
      div = this.document.getElementById('one')
      element = $(div)

      assert.same element, $(element)