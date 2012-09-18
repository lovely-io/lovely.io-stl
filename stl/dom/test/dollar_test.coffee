#
# The `$` function unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')


describe '$', ->
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

  dom = (callback)->
    Test.load module, "/dollar.html", ($, window)->
      callback($, window, window.document)

  describe 'css search', ->

    it "should correctly find elements by ID", dom ($, window, document)->
      search = $('#one')

      search.should.be.instanceOf $.NodeList
      search.should.have.length 1
      search[0].should.be.instanceOf $.Element
      search[0]._.should.be.same     document.getElementById('one')

    it "should correctly find elements by class name", dom ($, window, document)->
      search = $('.one')

      search.should.be.instanceOf $.NodeList
      search.should.have.length 3
      search[0].should.be.instanceOf $.Element
      search[1].should.be.instanceOf $.Element
      search[2].should.be.instanceOf $.Element
      search[0]._.should.be.same document.querySelector('#one   .one')
      search[1]._.should.be.same document.querySelector('#two   .one')
      search[2]._.should.be.same document.querySelector('#three .one')


    it "should correctly find elements in a context", dom ($, window, document)->
      search = $('.one, .two', document.getElementById('one'))

      search.should.be.instanceOf $.NodeList
      search.should.have.length 2
      search[0]._.should.be.same document.querySelector('#one .one')
      search[1]._.should.be.same document.querySelector('#one .two')


    it "should accept dom-wrappers as the context", dom ($, window, document)->
      element = $(document.getElementById('two'))
      search  = $('.one, .two', element)

      search.should.be.instanceOf $.NodeList
      search.should.have.length   2
      search[0]._.should.be.same document.querySelector('#two .one')
      search[1]._.should.be.same document.querySelector('#two .two')


    it 'should return an empty list when nothing found by id', dom ($)->
      result = $('#non-existing')

      result.should.be.instanceOf $.NodeList
      result.should.have.length 0


    it 'should return an empty list when nothing was found by a css selector', dom ($)->
      result = $('div.non .existing')

      result.should.be.instanceOf $.NodeList
      result.should.have.length 0


  describe 'HTML to NodeList conversion', ->

    it "should create a node-list out of a piece of HTML", dom ($)->
      search = $('<span>one</span><b>two</b>')

      search.should.be.instanceOf $.NodeList
      search.should.have.length   2
      search[0].should.be.instanceOf $.Element
      search[1].should.be.instanceOf $.Element
      search[0]._.tagName.should.eql   'SPAN'
      search[1]._.tagName.should.eql   'B'
      search[0]._.innerHTML.should.eql 'one'
      search[1]._.innerHTML.should.eql 'two'


  describe 'window wrapping', ->

    it 'should return a window wrapper for a window', dom ($, window)->
      win = $(window)

      win.should.be.instanceOf $.Window
      win._.should.be.same window

    it 'should return the same window wrapper back', dom ($, window)->
      win = $(window)

      $(win).should.be.same win

  describe 'document wrapping', ->

    it 'should wrap a document', dom ($, window, document)->
      doc = $(document)

      doc.should.be.instanceOf $.Document
      doc._.should.be.same document

    it 'should return the same wrapper if already wrapped', dom ($, window, document)->
      doc = $(document)

      $(doc).should.be.same doc

  describe 'element wrapping', ->

    it 'should return a wrapper for a dom-element', dom ($, window, document)->
      div = document.getElementById('one')
      element = $(div)

      element.should.be.instanceOf $.Element
      element._.should.be.same div

    it 'should return the same wrapper if an element is already wrapped', dom ($, window, document)->
      div = document.getElementById('one')
      element = $(div)

      $(element).should.be.same element