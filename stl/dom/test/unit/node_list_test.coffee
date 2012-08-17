#
# The `NodeList` module unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Browser} = require('../test_helper')

Browser.respond "/node_list.html": """
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
  describe "\b#constructor", ->
    get = (callback)->
      (done)->
        Browser.open "/node_list.html", ($, window)->
          callback($.NodeList, $, window, window.document)
          done()

    it "should accept a list of raw dom-elements as an argument", get (NodeList, $, window, document)->
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
    get = (callback)->
      (done)->
        Browser.open "/node_list.html", ($, window)->
          list = new $.NodeList([
            window.document.getElementById('one'),
            window.document.getElementById('two'),
            window.document.getElementById('three')])

          callback(list, $, window, window.document)
          done()

    it "should call the setter methods on every item on the list", get (list)->
      list.setClass('test')
      list.map('getClass').toArray().should.eql ['test', 'test', 'test']

    it "should return search itself back to the code by default", get (list)->
      list.addClass('test').should.equal list

    it "should return the result of the first element when calls a getter method", get (list)->
      list.attr('id').should.eql 'one'

    it "should return 'null' back when the NodeList is empty", get (list, $)->
      (new $.NodeList([]).addClass('test') is null).should.be.true

