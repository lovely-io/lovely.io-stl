#
# The `Element` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, load} = require('../test_helper')

load_Element = (test, callback) ->
  load "/test.html", test, (dom) ->
    if callback then callback.call(test, dom.Element)
    else dom.Element


describe 'Element', module,
  "direct instance":
    topic: -> load_Element(this)

    "should allow to create new elements": (Element) ->
      element = new Element('div')

      assert.instanceOf element, Element
      assert.equal element._.tagName, 'DIV'

    "should bypass the properties in place": (Element) ->
      element = new Element('div', id: 'my-id', html: 'my-html', class: 'my-class')

      assert.equal element._.id,        'my-id'
      assert.equal element._.innerHTML, 'my-html'
      assert.equal element._.className, 'my-class'

    "should accept raw dom-elements as the first attribute": (Element) ->
      raw_dom = this.browser.document.createElement('div')
      element = new Element(raw_dom)

      assert.same element._, raw_dom


  "inheritance usage":
    topic: -> load_Element this, (Element) ->
      new this.Lovely.Class Element,
        constructor: (tag, id, html) ->
          this.$super(tag, id: id, html: html)

    "should inherit the Element": (MyElement) ->
      element = new MyElement('div')

      assert.instanceOf element, MyElement
      assert.instanceOf element, this.Element

    "should use correct tag name": (MyElement) ->
      element = new MyElement('div')

      assert.equal element._.tagName, 'DIV'

    "should bypass the 'id' and 'html' properties": (MyElement) ->
      element = new MyElement('div', 'my-id', 'my-html')

      assert.equal element._.id,        'my-id'
      assert.equal element._.innerHTML, 'my-html'

  "dynamic typecasting":
    topic: -> load_Element this, (Element) ->
      this.Wrapper.set 'table', new this.Lovely.Class Element,
        constructor: (one, two) ->
          this.$super(one, two)

      return Element

    "should automatically typecast elements by tag name": (Element) ->
      table = new Element('table')

      assert.instanceOf table, this.Wrapper.get('table')
      assert.instanceOf table, Element

    "should bypass the attributes in place": (Element) ->
      table = new Element('table', id: 'my-id', class: 'my-class')

      assert.equal table._.id,        'my-id'
      assert.equal table._.className, 'my-class'

    "should work with raw dom-elements as well": (Element) ->
      raw_dom = this.browser.document.createElement('table')
      element = new Element(raw_dom)

      assert.instanceOf element, this.Wrapper.get('table')
      assert.instanceOf element, Element


