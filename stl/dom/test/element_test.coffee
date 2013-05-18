#
# The `Element` unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

describe 'Element', ->
  $ = window = document = Element = MyElement = Table = null

  before Test.load (dom, win)->
    $        = dom
    window   = win
    document = win.document
    Element  = $.Element


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
      MyElement = Element.inherit
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

  describe "private wrappers casting method", ->
    element = null

    before ->
      element    = document.createElement('div')
      element.id = 'test'
      document.body.appendChild(element)

      MyElement = Element.inherit({})

    it "should typecast the element into the specified wrapper", ->
      cast = $('#test').cast(MyElement)
      cast.should.be.instanceOf MyElement
      cast._.should.equal element

    it "should register the elements with the new typecast", ->
      cast = $('#test').cast(MyElement)
      $('#test')[0].should.equal cast


  describe "\b.resolve(...) method", ->
    element = null

    before ->
      element    = document.createElement('div')
      element.id = 'test'
      document.body.appendChild(element)
      element    = $('#test')[0]

    it "should resolve an element by a css rule", ->
      Element.resolve('#test').should.equal element

    it "should resolve an element from a raw dom-element reference", ->
      Element.resolve(element._).should.equal element

    it "should resolve an element from a dom.NodeList", ->
      Element.resolve($('#test')).should.equal element

    it "should return null for a non existing elements", ->
      (Element.resolve('#non-existing-element') is null).should.be.true
      (Element.resolve(undefined) is null).should.be.true
      (Element.resolve(null) is null).should.be.true
