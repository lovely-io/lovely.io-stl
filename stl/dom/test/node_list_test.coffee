#
# The `NodeList` module unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

Test.set "/node_list.html", """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="one"></div>
      <div id="two"></div>
      <div id="three"></div>
    </body>
  </html>
  """


describe 'NodeList', ->
  NodeList = $ = window = document = null

  before Test.load module, "/node_list.html", (dom, win)->
    $        = dom
    NodeList = $.NodeList
    window   = win
    document = win.document


  describe "\b#constructor", ->

    it "should accept a list of raw dom-elements as an argument", ->
      element1 = document.getElementById('one')
      element2 = document.getElementById('two')

      search   = new NodeList([element1, element2])

      search.should.be.instanceOf NodeList
      search.should.have.length   2
      search[0].should.be.instanceOf $.Element
      search[1].should.be.instanceOf $.Element
      search[0]._.should.equal element1
      search[1]._.should.equal element2


  describe "DOM methods", ->
    list = null

    before ->
      list = new $.NodeList([
        document.getElementById('one'),
        document.getElementById('two'),
        document.getElementById('three')])

    it "should call the setter methods on every item on the list", ->
      list.setClass('test')
      list.map('getClass').toArray().should.eql ['test', 'test', 'test']

    it "should return search itself back to the code by default", ->
      list.addClass('test').should.equal list

    it "should return the result of the first element when calls a getter method", ->
      list.attr('id').should.eql 'one'

    it "should return 'null' back when the NodeList is empty", ->
      (new $.NodeList([]).addClass('test') is null).should.be.true

  describe "\b#exists()", ->

    it "should return 'false' for empty lists", ->
      list = new NodeList([])
      list.exists().should.be.false

    it "should return 'true' for non-empty lists", ->
      list = new NodeList([document.getElementById('one')])
      list.exists().should.be.true




