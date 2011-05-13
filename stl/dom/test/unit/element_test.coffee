#
# The `Element` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../test_helper'

describe 'Element', module,
  "direct instance":
    topic: ->
      callback = this.callback
      Browser.open "/test.html", (err, browser) ->
        callback(err, browser.window.Lovely.modules.dom.Element)

    "should allow to create new elements": (Element) ->
      element = new Element('div', id: "my-element")

      assert.instanceOf element, Element
      assert.equal element._.tagName, 'DIV'
      assert.equal element._.id, 'my-element'