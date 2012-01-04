#
# The `NodeList` module unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load} = require('../test_helper')

server.respond "/node_list.html": """
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


describe 'NodeList', module,
  "constructor":
    topic: ->
      load "/node_list.html", this, (dom)-> dom.NodeList

    "should accept a list of raw dom-elements as an argument": (NodeList)->
      element1 = this.document.getElementById('one')
      element2 = this.document.getElementById('two')

      search   = new NodeList([element1, element2])

      assert.instanceOf search,      NodeList
      assert.lengthOf   search,      2
      assert.instanceOf search[0],   this.Element
      assert.instanceOf search[0],   this.Element
      assert.same       search[0]._, element1
      assert.same       search[1]._, element2

  "DOM methods":
    topic: ->
      load "/node_list.html", this, (dom)->
        new dom.NodeList([
          this.document.getElementById('one'),
          this.document.getElementById('two'),
          this.document.getElementById('three')])

    "should call the setter methods on every item on the list": (list)->
      list.setClass('test')
      assert.deepEqual list.map('getClass').toArray(), ['test', 'test', 'test']

    "should return search itself back to the code by default": (list)->
      assert.same list.addClass('test'), list

    "should return the result of the first element when calls a getter method": (list)->
      assert.equal list.attr('id'), 'one'

    "should return 'null' back when the NodeList is empty": (list)->
      assert.isNull new this.NodeList([]).addClass('test')

