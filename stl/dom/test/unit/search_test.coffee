#
# The `Search` module unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load} = require('../test_helper')

server.respond "/search.html": """
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


Search = ->
  load "/search.html", this, (dom)-> dom.Search


describe 'Search', module,
  "constructor":
    topic: Search

    "should correctly find elements by ID": (Search)->
      search = new Search('#one')

      assert.instanceOf search,      Search
      assert.length     search,      1
      assert.instanceOf search[0],   this.Element
      assert.same       search[0]._, this.document.getElementById('one')

    "should correctly find elements by class name": (Search)->
      search = new Search('.one')

      assert.instanceOf search,      Search
      assert.length     search,      3
      assert.instanceOf search[0],   this.Element
      assert.instanceOf search[1],   this.Element
      assert.instanceOf search[2],   this.Element
      assert.same       search[0]._, this.document.querySelector('#one   .one')
      assert.same       search[1]._, this.document.querySelector('#two   .one')
      assert.same       search[2]._, this.document.querySelector('#three .one')

    "should correctly find elements in a context": (Search)->
      search = new Search('.one, .two', this.document.getElementById('one'))

      assert.instanceOf search,      Search
      assert.length     search,      2
      assert.same       search[0]._, this.document.querySelector('#one .one')
      assert.same       search[1]._, this.document.querySelector('#one .two')


    "should accept dom-wrappers as the context": (Search)->
      element = this.dom(this.document.getElementById('two'))
      search  = new Search('.one, .two', element)

      assert.length search, 2
      assert.same   search[0]._, this.document.querySelector('#two .one')
      assert.same   search[1]._, this.document.querySelector('#two .two')

    "should accept a list of raw dom-elements as an argument": (Search)->
      element1 = this.document.getElementById('one')
      element2 = this.document.getElementById('two')

      search   = new Search([element1, element2])

      assert.instanceOf search,      Search
      assert.length     search,      2
      assert.instanceOf search[0],   this.Element
      assert.instanceOf search[0],   this.Element
      assert.same       search[0]._, element1
      assert.same       search[1]._, element2

    "should accept a list of dom-wrappers as an argument": (Search)->
      element1 = this.dom(this.document.getElementById('one'))
      element2 = this.dom(this.document.getElementById('two'))

      search   = new Search([element1, element2])

      assert.instanceOf search,    Search
      assert.length     search,    2
      assert.same       search[0], element1
      assert.same       search[1], element2

    "should create a node-list out of a piece of HTML": (Search)->
      search = new Search('<span>one</span><b>two</b>')

      assert.instanceOf search, Search
      assert.length     search, 2
      assert.instanceOf search[0], this.Element
      assert.instanceOf search[1], this.Element
      assert.equal      search[0]._.tagName, 'SPAN'
      assert.equal      search[1]._.tagName, 'B'
      assert.equal      search[0]._.innerHTML, 'one'
      assert.equal      search[1]._.innerHTML, 'two'

  "DOM methods":
    topic: Search

    "should call the setter methods on every item on the list": (Search)->
      search = new Search('<div></div><div></div><div></div>')

      search.addClass('test')

      assert.deepEqual search.map('getClass').toArray(), ['test', 'test', 'test']

    "should return search itself back to the code by default": (Search)->
      search = new Search('<div></div>')

      assert.same search.addClass('test'), search

    "should return 'null' back when the Search is empty": (Search)->
      assert.isNull new Search([]).addClass('test')

    "should return the result of the first element when calls a getter method": (Search)->
      search = new Search('<div>one</div><div>two</div><div>three</div>')

      #assert.equal search.html(), 'one'