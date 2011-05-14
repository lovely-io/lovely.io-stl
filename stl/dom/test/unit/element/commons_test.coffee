#
# The Element common methods section unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../../test_helper'

server.get "/commons.html", (req, resp) ->
  resp.send """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="test-attr" data-test="test"></div>
    </body>
  </html>
  """

load = (vow, callback) ->
  Browser.open "/commons.html", (err, browser) ->
    vow.browser = browser
    vow.Lovely  = browser.window.Lovely
    vow.Wrapper = vow.Lovely.modules.dom.Wrapper
    vow.Element = vow.Lovely.modules.dom.Element
    vow.callback(err, if callback then callback.call(vow, vow.Element) else vow.Element)


describe 'Element Commons', module,
  "#attr":
    topic: -> load this, (Element)->
      new Element(this.browser.document.getElementById('test-attr'))

    "\b('name')":
      topic: (element) -> element

      "should read a property attribute": (element) ->
        assert.equal element.attr('id'), 'test-attr'

      "should read the 'data-test' attribute": (element) ->
        assert.equal element.attr('data-test'), 'test'

      "should return 'null' for non existing attributes": (element) ->
        assert.isNull element.attr('nonexistent')


    "\b('name', 'value')":
      topic: (element) -> element

      "should return the element back": (element) ->
        assert.same element.attr('title', 'text'), element

      "should set property attributes": (element) ->
        element.attr('title', 'new value')
        assert.equal element._.title, 'new value'

      "should set non-property attributes": (element) ->
        element.attr('data-new', 'something')
        assert.equal element._.getAttribute('data-new'), 'something'


    "\b({name: 'value'})":
      topic: (element) -> element

      "should return the element back afterwards": (element) ->
        assert.same element.attr(smth: 'value'), element

      "should set all the attributes from the hash": (element) ->
        element.attr
          test_attr1: 'value1'
          test_attr2: 'value2'

        assert.equal element._.getAttribute('test_attr1'), 'value1'
        assert.equal element._.getAttribute('test_attr2'), 'value2'


    "\b('name', null)":
      topic: (element) -> element

      "should remove the attribute": (element) ->
        element.attr('something', 'something')
        assert.equal element.attr('something'), 'something'

        element.attr('something', null)
        assert.isNull element.attr('something')
