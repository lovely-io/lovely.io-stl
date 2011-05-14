#
# The Element common methods section unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../../test_helper'

server.respond "/commons.html": """
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

get_element = (test)->
  load_element("/commons.html", test, 'test-attr')


describe 'Element Commons', module,
  "#attr":

    "\b('name')":
      topic: -> get_element(this)

      "should read a property attribute": (element) ->
        assert.equal element.attr('id'), 'test-attr'

      "should read the 'data-test' attribute": (element) ->
        assert.equal element.attr('data-test'), 'test'

      "should return 'null' for non existing attributes": (element) ->
        assert.isNull element.attr('nonexistent')


    "\b('name', 'value')":
      topic: -> get_element(this)

      "should return the element back": (element) ->
        assert.same element.attr('title', 'text'), element

      "should set property attributes": (element) ->
        element.attr('title', 'new value')
        assert.equal element._.title, 'new value'

      "should set non-property attributes": (element) ->
        element.attr('data-new', 'something')
        assert.equal element._.getAttribute('data-new'), 'something'


    "\b({name: 'value'})":
      topic: -> get_element(this)

      "should return the element back afterwards": (element) ->
        assert.same element.attr(smth: 'value'), element

      "should set all the attributes from the hash": (element) ->
        element.attr
          test_attr1: 'value1'
          test_attr2: 'value2'

        assert.equal element._.getAttribute('test_attr1'), 'value1'
        assert.equal element._.getAttribute('test_attr2'), 'value2'


    "\b('name', null)":
      topic: -> get_element(this)

      "should remove the attribute": (element) ->
        element.attr('something', 'something')
        assert.equal element.attr('something'), 'something'

        element.attr('something', null)
        assert.isNull element.attr('something')
