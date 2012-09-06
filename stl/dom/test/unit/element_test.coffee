#
# The `Element` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('../../../../cli/lovely')


describe 'Element', ->

  describe "direct instance", ->
    get = (callback)->
      Test.load module, ($, window)->
        callback($.Element, $, window)

    it "should allow to create new elements", get (Element) ->
      element = new Element('div')

      element.should.be.instanceOf Element
      element._.tagName.should.eql 'DIV'

    it "should bypass the properties in place", get (Element)->
      element = new Element('div', id: 'my-id', html: 'my-html', class: 'my-class')

      element._.id.should.eql        'my-id'
      element._.innerHTML.should.eql 'my-html'
      element._.className.should.eql 'my-class'

    it "should accept raw dom-elements as the first attribute", get (Element, $, window)->
      raw_dom = window.document.createElement('div')
      element = new Element(raw_dom)

      element._.should.be.equal raw_dom


  describe "inheritance usage", ->
    get = (callback)->
      Test.load module, ($, window)->
        MyElement = new window.Lovely.Class $.Element,
          constructor: (tag, id, html) ->
            this.$super(tag, id: id, html: html)

        callback(MyElement, $, window)


    it "should inherit the Element", get (MyElement, $) ->
      element = new MyElement('div')

      element.should.be.instanceOf MyElement
      element.should.be.instanceOf $.Element

    it "should use correct tag name", get (MyElement) ->
      element = new MyElement('div')

      element._.tagName.should.eql 'DIV'

    it "should bypass the 'id' and 'html' properties", get (MyElement) ->
      element = new MyElement('div', 'my-id', 'my-html')

      element._.id.should.eql        'my-id'
      element._.innerHTML.should.eql 'my-html'

  describe "dynamic typecasting", ->
    get = (callback)->
      Test.load module, ($, window)->
        $.Wrapper.set 'table', new window.Lovely.Class $.Element,
          constructor: (one, two) ->
            this.$super(one, two)

        callback($.Element, $, window)

    it "should automatically typecast elements by tag name", get (Element, $)->
      table = new Element('table')

      table.should.be.instanceOf $.Wrapper.get('table')
      table.should.be.instanceOf $.Element

    it "should bypass the attributes in place", get (Element)->
      table = new Element('table', id: 'my-id', class: 'my-class')

      table._.id.should.eql        'my-id'
      table._.className.should.eql 'my-class'

    it "should work with raw dom-elements as well", get (Element, $, window)->
      raw_dom = window.document.createElement('table')
      element = new Element(raw_dom)

      element.should.be.instanceOf $.Wrapper.get('table')
      element.should.be.instanceOf Element


