#
# The `$` function unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

Test.set "/dollar.html": """
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


describe '$', ->
  $ = window = document = null

  before Test.load '/dollar.html', (dom, win)->
    $        = dom
    window   = win
    document = win.document

  describe 'css search', ->

    it "should correctly find elements by ID", ->
      search = $('#one')

      search.should.be.instanceOf    $.NodeList
      search.should.have.length 1
      search[0].should.be.instanceOf $.Element
      search[0]._.should.be.equal     document.getElementById('one')

    it "should correctly find elements by class name", ->
      search = $('.one')

      search.should.be.instanceOf $.NodeList
      search.should.have.length 3
      search[0].should.be.instanceOf $.Element
      search[1].should.be.instanceOf $.Element
      search[2].should.be.instanceOf $.Element
      search[0]._.should.be.equal document.querySelector('#one   .one')
      search[1]._.should.be.equal document.querySelector('#two   .one')
      search[2]._.should.be.equal document.querySelector('#three .one')


    it "should correctly find elements in a context", ->
      search = $('.one, .two', document.getElementById('one'))

      search.should.be.instanceOf $.NodeList
      search.should.have.length 2
      search[0]._.should.be.equal document.querySelector('#one .one')
      search[1]._.should.be.equal document.querySelector('#one .two')


    it "should accept dom-wrappers as the context", ->
      element = $(document.getElementById('two'))
      search  = $('.one, .two', element)

      search.should.be.instanceOf $.NodeList
      search.should.have.length   2
      search[0]._.should.be.equal document.querySelector('#two .one')
      search[1]._.should.be.equal document.querySelector('#two .two')


    it 'should return an empty list when nothing found by id', ->
      result = $('#non-existing')

      result.should.be.instanceOf $.NodeList
      result.should.have.length 0


    it 'should return an empty list when nothing was found by a css selector', ->
      result = $('div.non .existing')

      result.should.be.instanceOf $.NodeList
      result.should.have.length 0


  describe 'HTML to NodeList conversion', ->

    it "should create a node-list out of a piece of HTML", ->
      search = $('<span>one</span><b>two</b>')

      search.should.be.instanceOf      $.NodeList
      search.should.have.length        2
      search[0].should.be.instanceOf   $.Element
      search[1].should.be.instanceOf   $.Element
      search[0]._.tagName.should.eql   'SPAN'
      search[1]._.tagName.should.eql   'B'
      search[0]._.innerHTML.should.eql 'one'
      search[1]._.innerHTML.should.eql 'two'


  describe 'window wrapping', ->

    it 'should return a window wrapper for a window', ->
      win = $(window)

      win.should.be.instanceOf $.Window
      win._.should.be.equal window

    it 'should return the same window wrapper back', ->
      win = $(window)

      $(win).should.be.equal win

  describe 'document wrapping', ->

    it 'should wrap a document', ->
      doc = $(document)

      doc.should.be.instanceOf $.Document
      doc._.should.be.equal document

    it 'should return the same wrapper if already wrapped', ->
      doc = $(document)

      $(doc).should.be.equal doc

  describe 'element wrapping', ->

    it 'should return a wrapper for a dom-element', ->
      div = document.getElementById('one')
      element = $(div)

      element.should.be.instanceOf $.Element
      element._.should.be.equal div

    it 'should return the same wrapper if an element is already wrapped', ->
      div = document.getElementById('one')
      element = $(div)

      $(element).should.be.equal element
