#
# The `Element` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../test_helper'

load = (vow, callback) ->
  Browser.open "/test.html", (err, browser) ->
    vow.browser = browser
    vow.Lovely  = browser.window.Lovely
    vow.Wrapper = vow.Lovely.modules.dom.Wrapper
    vow.Element = vow.Lovely.modules.dom.Element
    vow.callback(err, if callback then callback.call(vow, vow.Element) else vow.Element)

describe 'Element', module,
  "direct instance":
    topic: -> load(this)

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
    topic: -> load this, (Element) ->
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
    topic: -> load this, (Element) ->
      this.Wrapper.TABLE = new this.Lovely.Class Element,
        constructor: (one, two) ->
          this.$super(one, two)

      return Element

    "should automatically typecast elements by tag name": (Element) ->
      table = new Element('table')

      assert.instanceOf table, this.Wrapper.TABLE
      assert.instanceOf table, Element

    "should bypass the attributes in place": (Element) ->
      table = new Element('table', id: 'my-id', class: 'my-class')

      assert.equal table._.id,        'my-id'
      assert.equal table._.className, 'my-class'

    "should work with raw dom-elements as well": (Element) ->
      raw_dom = this.browser.document.createElement('table')
      element = new Element(raw_dom)

      assert.instanceOf element, this.Wrapper.TABLE
      assert.instanceOf element, Element


