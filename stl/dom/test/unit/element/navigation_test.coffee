#
# Element navigation module unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../../test_helper'

server.respond "/navigation.html": """
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
        <div class="three">#three .three</div>
      </div>
    </body>
  </html>
  """

find_element = (css_rule)->
  ->
    load "/navigation.html", this, (dom)->
      dom(this.document.querySelector(css_rule))


describe "Element Navigation", module,
  "#match('css_rule')":
    topic: find_element('#one .one')

    "should say 'true' if it match the rule": (element)->
      assert.isTrue element.match('#one .one')

    "should say 'false' if it doesn't match the rule": (element)->
      assert.isFalse element.match('#one .two')

  "#find('css_rule')":
    topic: find_element('#one')

    "should search in the element": (element)->
      search = element.find('.one')

      assert.instanceOf search, this.Search
      assert.length     search, 1
      assert.instanceOf search[0], this.Element
      assert.same       search[0]._, this.document.querySelector('#one .one')

    "should return an empty list if nothing found": (element)->
      search = element.find('.non-existing')

      assert.instanceOf search, this.Search
      assert.length     search, 0

    "should allow a raw DOM elements search": (element)->
      search = element.find('.one, .two', true)

      assert.isFalse search instanceof this.Search
      assert.length  search, 2
      assert.equal   search[0], this.document.querySelector('#one .one')
      assert.equal   search[1], this.document.querySelector('#one .two')

  "#first('css_rule')":
    topic: find_element('#one')

    "should find the first matching element": (element)->
      first = element.first('.two')

      assert.instanceOf first, this.Element
      assert.same       first._, this.document.querySelector('#one .two')

    "should find the very first element when called without a css-rule": (element)->
      first = element.first()

      assert.instanceOf first, this.Element
      assert.same       first._, this.document.querySelector('#one .one')

  "#parent('css-rule')":
    topic: find_element('#one .one')

    "should return the first parent when called without a css-rule": (element)->
      parent = element.parent()

      assert.instanceOf parent,   this.Element
      assert.same       parent._, this.document.querySelector('#one')

    "should return the first matching parent when called with a css-rule": (element)->
      parent = element.parent('body')

      assert.instanceOf parent,   this.Element
      assert.same       parent._, this.document.body

  "#parents('css-rule')":
    topic: find_element('#one .one')

    "should return the list of all parents when called with a css-rule": (element)->
      parents = element.parents()

      assert.instanceOf parents, this.Search
      assert.length     parents, 3
      assert.same       parents[0]._, this.document.querySelector('#one')
      assert.same       parents[1]._, this.document.body
      assert.same       parents[2]._, this.document.documentElement

    "should filter the list by a given css-rule": (element)->
      parents = element.parents('body')

      assert.instanceOf parents, this.Search
      assert.length     parents, 1
      assert.same       parents[0]._, this.document.body


  "#children('css_rule')":
    topic: find_element('#one')

    "should return all child elements when called without a css-rule": (element)->
      result = element.children()

      assert.instanceOf result, this.Search
      assert.length     result, 2
      assert.instanceOf result[0],   this.Element
      assert.instanceOf result[1],   this.Element
      assert.same       result[0]._, this.document.querySelector('#one .one')
      assert.same       result[1]._, this.document.querySelector('#one .two')

    "should filter the result by the css-rule": (element)->
      result = element.children('.one')

      assert.length     result, 1
      assert.same       result[0]._, this.document.querySelector('#one .one')


  "#siblings('css-rule')":
    topic: find_element('#three .two')

    "should return the list of all siblings when called without a css-rule": (element)->
      siblings = element.siblings()

      assert.instanceOf siblings,      this.Search
      assert.length     siblings,      2
      assert.instanceOf siblings[0],   this.Element
      assert.instanceOf siblings[1],   this.Element
      assert.same       siblings[0]._, this.document.querySelector('#three .one')
      assert.same       siblings[1]._, this.document.querySelector('#three .three')

    "should return the list of matching siblings only when called with a css-rule": (element)->
      siblings = element.siblings('.one')

      assert.instanceOf siblings,      this.Search
      assert.length     siblings,      1
      assert.instanceOf siblings[0],   this.Element
      assert.same       siblings[0]._, this.document.querySelector('#three .one')

   "#nextSiblings('css-rule')":
    topic: find_element('#three .one')

    "should return a list of all the next siblings when called without a css-rule": (element)->
      siblings = element.nextSiblings()

      assert.instanceOf siblings,      this.Search
      assert.length     siblings,      2
      assert.instanceOf siblings[0],   this.Element
      assert.instanceOf siblings[1],   this.Element
      assert.same       siblings[0]._, this.document.querySelector('#three .two')
      assert.same       siblings[1]._, this.document.querySelector('#three .three')

    "should return only matching siblings when called with a css-rule": (element)->
      siblings = element.nextSiblings('.two')

      assert.instanceOf siblings,      this.Search
      assert.length     siblings,      1
      assert.instanceOf siblings[0],   this.Element
      assert.same       siblings[0]._, this.document.querySelector('#three .two')

  "#previousSiblings('css-rule')":
    topic: find_element('#three .three')

    "should return a list of all the next siblings when called without a css-rule": (element)->
      siblings = element.previousSiblings()

      assert.instanceOf siblings,      this.Search
      assert.length     siblings,      2
      assert.instanceOf siblings[0],   this.Element
      assert.instanceOf siblings[1],   this.Element
      assert.same       siblings[0]._, this.document.querySelector('#three .two')
      assert.same       siblings[1]._, this.document.querySelector('#three .one')

    "should return only matching siblings when called with a css-rule": (element)->
      siblings = element.previousSiblings('.two')

      assert.instanceOf siblings,      this.Search
      assert.length     siblings,      1
      assert.instanceOf siblings[0],   this.Element
      assert.same       siblings[0]._, this.document.querySelector('#three .two')

  "#nextSibling('css-rule')":
    topic: find_element('#three .one')

    "should return the very next sibling element when called without a css-rule": (element)->
      sibling = element.nextSibling()

      assert.instanceOf sibling,   this.Element
      assert.same       sibling._, this.document.querySelector('#three .two')

    "should return a matching next sibling when called with a css-rule": (element)->
      sibling = element.nextSibling('.three')

      assert.instanceOf sibling,   this.Element
      assert.same       sibling._, this.document.querySelector('#three .three')

  "#previousSibling('css-rule')":
    topic: find_element('#three .three')

    "should return the very previous sibling element when called without a css-rule": (element)->
      sibling = element.previousSibling()

      assert.instanceOf sibling,   this.Element
      assert.same       sibling._, this.document.querySelector('#three .two')

    "should return a matching previous sibling when called with a css-rule": (element)->
      sibling = element.previousSibling('.one')

      assert.instanceOf sibling,   this.Element
      assert.same       sibling._, this.document.querySelector('#three .one')
