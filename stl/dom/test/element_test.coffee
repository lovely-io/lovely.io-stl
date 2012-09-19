#
# The `Element` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

describe 'Element', ->
  $ = window = document = Element = MyElement = Table = null

  before Test.load(module, (dom, win)->
    $        = dom
    window   = win
    document = win.document
    Element  = $.Element)


  describe "direct instance", ->

    it "should allow to create new elements", ->
      element = new Element('div')

      element.should.be.instanceOf Element
      element._.tagName.should.eql 'DIV'

    it "should bypass the properties in place", ->
      element = new Element('div', id: 'my-id', html: 'my-html', class: 'my-class')

      element._.id.should.eql        'my-id'
      element._.innerHTML.should.eql 'my-html'
      element._.className.should.eql 'my-class'

    it "should accept raw dom-elements as the first attribute", ->
      raw_dom = document.createElement('div')
      element = new Element(raw_dom)

      element._.should.be.equal raw_dom


  describe "inheritance usage", ->
    before ->
      MyElement = new window.Lovely.Class $.Element,
        constructor: (tag, id, html) ->
          this.$super(tag, id: id, html: html)


    it "should inherit the Element", ->
      element = new MyElement('div')

      element.should.be.instanceOf MyElement
      element.should.be.instanceOf $.Element

    it "should use correct tag name", ->
      element = new MyElement('div')

      element._.tagName.should.eql 'DIV'

    it "should bypass the 'id' and 'html' properties", ->
      element = new MyElement('div', 'my-id', 'my-html')

      element._.id.should.eql        'my-id'
      element._.innerHTML.should.eql 'my-html'

  describe "dynamic typecasting", ->
    before ->
      Table = new window.Lovely.Class $.Element,
        constructor: (one, two) ->
          this.$super(one, two)

      $.Wrapper.set 'table', Table

    it "should automatically typecast elements by tag name", ->
      table = new Element('table')

      table.should.be.instanceOf Table
      table.should.be.instanceOf $.Element

    it "should bypass the attributes in place", ->
      table = new Element('table', id: 'my-id', class: 'my-class')

      table._.id.should.eql        'my-id'
      table._.className.should.eql 'my-class'

    it "should work with raw dom-elements as well", ->
      raw_dom = document.createElement('table')
      element = new Element(raw_dom)

      element.should.be.instanceOf $.Wrapper.get('table')
      element.should.be.instanceOf Element

  describe "private wrappers casting method", ->
    element = null

    before ->
      element    = document.createElement('div')
      element.id = 'test'
      document.body.appendChild(element)

      MyElement = new window.Lovely.Class Element

    it "should typecast the element into the specified wrapper", ->
      cast = $('#test').cast(MyElement)
      cast.should.be.instanceOf MyElement
      cast._.should.equal element

    it "should register the elements with the new typecast", ->
      cast = $('#test').cast(MyElement)
      $('#test')[0].should.equal cast



