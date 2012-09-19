#
# Element navigation module unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

Test.set "/navigation.html", """
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

describe "Element Navigation", ->

  $ = window = document = element = null

  get = (css_rule)->
    before Test.load module, "/navigation.html", (dom, win)->
      $        = dom
      window   = win
      document = win.document
      element  = new $.Element(window.document.querySelector(css_rule))


  describe "#match('css_rule')", ->
    element = get('#one .one')

    it "should say 'true' if it match the rule", ->
      element.match('#one .one').should.be.true

    it "should say 'false' if it doesn't match the rule", ->
      element.match('#one .two').should.be.false

  describe "#find('css_rule')", ->
    element = get('#one')

    it "should search in the element", ->
      search = element.find('.one')

      search.should.be.instanceOf    $.NodeList
      search.should.have.length      1
      search[0].should.be.instanceOf $.Element
      search[0]._.should.equal document.querySelector('#one .one')

    it "should return an empty list if nothing found", ->
      search = element.find('.non-existing')

      search.should.be.instanceOf $.NodeList
      search.should.have.length   0

    it "should allow a raw DOM elements search", ->
      search = element.find('.one, .two', true)

      search.should.not.be.instanceOf $.NodeList
      search.should.be.instanceOf     Array
      search.should.have.length       2
      search[0].should.equal document.querySelector('#one .one')
      search[1].should.equal document.querySelector('#one .two')

  describe "#first('css_rule')", ->
    element = get('#one')

    it "should find the first matching element", ->
      first = element.first('.two')

      first.should.be.instanceOf $.Element
      first._.should.equal       document.querySelector('#one .two')

    it "should find the very first element when called without a css-rule", ->
      first = element.first()

      first.should.be.instanceOf $.Element
      first._.should.equal       document.querySelector('#one .one')

  describe "#parent('css-rule')", ->
    element = get('#one .one')

    it "should return the first parent when called without a css-rule", ->
      parent = element.parent()

      parent.should.be.instanceOf $.Element
      parent._.should.equal       document.querySelector('#one')

    it "should return the first matching parent when called with a css-rule", ->
      parent = element.parent('body')

      parent.should.be.instanceOf $.Element
      parent._.should.equal       document.body

  describe "#parents('css-rule')", ->
    element = get('#one .one')

    it "should return the list of all parents when called with a css-rule", ->
      parents = element.parents()

      parents.should.be.instanceOf $.NodeList
      parents.should.have.length   3
      parents[0]._.should.equal    document.querySelector('#one')
      parents[1]._.should.equal    document.body
      parents[2]._.should.equal    document.documentElement

    it "should filter the list by a given css-rule", ->
      parents = element.parents('body')

      parents.should.be.instanceOf $.NodeList
      parents.should.have.length   1
      parents[0]._.should.equal    document.body


  describe "#children('css_rule')", ->
    element = get('#one')

    it "should return all child elements when called without a css-rule", ->
      result = element.children()

      result.should.be.instanceOf    $.NodeList
      result.should.have.length      2
      result[0].should.be.instanceOf $.Element
      result[1].should.be.instanceOf $.Element
      result[0]._.should.equal       document.querySelector('#one .one')
      result[1]._.should.equal       document.querySelector('#one .two')

    it "should filter the result by the css-rule", ->
      result = element.children('.one')

      result.should.have.length 1
      result[0]._.should.equal document.querySelector('#one .one')


  describe "#siblings('css-rule')", ->
    element = get('#three .two')

    it "should return the list of all siblings when called without a css-rule", ->
      siblings = element.siblings()

      siblings.should.be.instanceOf    $.NodeList
      siblings.should.have.length      2
      siblings[0].should.be.instanceOf $.Element
      siblings[1].should.be.instanceOf $.Element
      siblings[0]._.should.equal       document.querySelector('#three .one')
      siblings[1]._.should.equal       document.querySelector('#three .three')

    it "should return the list of matching siblings only when called with a css-rule", ->
      siblings = element.siblings('.one')

      siblings.should.be.instanceOf    $.NodeList
      siblings.should.have.length      1
      siblings[0].should.be.instanceOf $.Element
      siblings[0]._.should.equal       document.querySelector('#three .one')


  describe "#nextSiblings('css-rule')", ->
    element = get('#three .one')

    it "should return a list of all the next siblings when called without a css-rule", ->
      siblings = element.nextSiblings()

      siblings.should.be.instanceOf    $.NodeList
      siblings.should.have.length      2
      siblings[0].should.be.instanceOf $.Element
      siblings[1].should.be.instanceOf $.Element
      siblings[0]._.should.equal       document.querySelector('#three .two')
      siblings[1]._.should.equal       document.querySelector('#three .three')

    it "should return only matching siblings when called with a css-rule", ->
      siblings = element.nextSiblings('.two')

      siblings.should.be.instanceOf    $.NodeList
      siblings.should.have.length      1
      siblings[0].should.be.instanceOf $.Element
      siblings[0]._.should.equal       document.querySelector('#three .two')


  describe "#previousSiblings('css-rule')", ->
    element = get('#three .three')

    it "should return a list of all the next siblings when called without a css-rule", ->
      siblings = element.previousSiblings()

      siblings.should.be.instanceOf    $.NodeList
      siblings.should.have.length      2
      siblings[0].should.be.instanceOf $.Element
      siblings[1].should.be.instanceOf $.Element
      siblings[0]._.should.equal       document.querySelector('#three .two')
      siblings[1]._.should.equal       document.querySelector('#three .one')

    it "should return only matching siblings when called with a css-rule", ->
      siblings = element.previousSiblings('.two')

      siblings.should.be.instanceOf    $.NodeList
      siblings.should.have.length      1
      siblings[0].should.be.instanceOf $.Element
      siblings[0]._.should.equal       document.querySelector('#three .two')


  describe "#nextSibling('css-rule')", ->
    element = get('#three .one')

    it "should return the very next sibling element when called without a css-rule", ->
      sibling = element.nextSibling()

      sibling.should.be.instanceOf $.Element
      sibling._.should.equal       document.querySelector('#three .two')

    it "should return a matching next sibling when called with a css-rule", ->
      sibling = element.nextSibling('.three')

      sibling.should.be.instanceOf $.Element
      sibling._.should.equal       document.querySelector('#three .three')


  describe "#previousSibling('css-rule')", ->
    element = get('#three .three')

    it "should return the very previous sibling element when called without a css-rule", ->
      sibling = element.previousSibling()

      sibling.should.be.instanceOf $.Element
      sibling._.should.equal       document.querySelector('#three .two')

    it "should return a matching previous sibling when called with a css-rule", ->
      sibling = element.previousSibling('.one')

      sibling.should.be.instanceOf $.Element
      sibling._.should.equal       document.querySelector('#three .one')
