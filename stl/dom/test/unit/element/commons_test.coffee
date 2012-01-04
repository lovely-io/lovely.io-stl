#
# The Element common methods section unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load_element} = require('../../test_helper')

server.respond "/commons.html": """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="test" data-test="test"></div>
    </body>
  </html>
  """

test_element = ->
  load_element("/commons.html", this, 'test')


describe 'Element Commons', module,
  "#attr":

    "\b('name')":
      topic: test_element

      "should read a property attribute": (element) ->
        assert.equal element.attr('id'), 'test'

      "should read the 'data-test' attribute": (element) ->
        assert.equal element.attr('data-test'), 'test'

      "should return 'null' for non existing attributes": (element) ->
        assert.isNull element.attr('nonexistent')


    "\b('name', 'value')":
      topic: test_element

      "should return the element back": (element) ->
        assert.same element.attr('title', 'text'), element

      "should set property attributes": (element) ->
        element.attr('title', 'new value')
        assert.equal element._.title, 'new value'

      "should set non-property attributes": (element) ->
        element.attr('data-new', 'something')
        assert.equal element._.getAttribute('data-new'), 'something'


    "\b({name: 'value'})":
      topic: test_element

      "should return the element back afterwards": (element) ->
        assert.same element.attr(smth: 'value'), element

      "should set all the attributes from the hash": (element) ->
        element.attr
          test_attr1: 'value1'
          test_attr2: 'value2'

        assert.equal element._.getAttribute('test_attr1'), 'value1'
        assert.equal element._.getAttribute('test_attr2'), 'value2'


    "\b('name', null)":
      topic: test_element

      "should remove the attribute": (element) ->
        element.attr('something', 'something')
        assert.equal element.attr('something'), 'something'

        element.attr('something', null)
        assert.isNull element.attr('something')


  "#hidden()":
    topic: test_element

    "should say 'true' when the element is hidden": (element)->
      element._.style.display = 'none'
      assert.isTrue element.hidden()

    "should say 'false' when the element is visible": (element)->
      element._.style.display = 'block'
      assert.isFalse element.hidden()

  "#visible()":
    topic: test_element

    "should say 'false' when the element is hidden": (element)->
      element._.style.display = 'none'
      assert.isFalse element.visible()

    "should say 'true' when the element is visible": (element)->
      element._.style.display = 'block'
      assert.isTrue element.visible()

  "#hide()":
    topic: test_element

    "should hide the element when it is visible": (element)->
      element._.style.display = 'block'
      element.hide()
      assert.equal element._.style.display, 'none'

    "should leave element hidden when it is not visible": (element)->
      element._.style.display = 'none'
      element.hide()
      assert.equal element._.style.display, 'none'

    "should return the element reference back": (element)->
      assert.same element.hide(), element

  "#show()":
    topic: test_element

    "should show an element if it's hidden": (element)->
      element._.style.display = 'none'
      element.show()
      assert.equal element._.style.display, 'block'

    "should leave a visible element visible": (element)->
      element._.style.display = 'inline'
      element.show()
      assert.equal element._.style.display, 'inline'

    "should return the element reference back": (element)->
      assert.same element.show(), element

  "#toggle()":
    topic: test_element

    "should show an element if it is hidden": (element)->
      element._.style.display = 'none'
      element.toggle()
      assert.equal element._.style.display, 'block'

    "should hide an element if it's visible": (element)->
      element._.style.display = 'block'
      element.toggle()
      assert.equal element._.style.display, 'none'

    "should return back a reference to the element": (element)->
      assert.same element.toggle(), element


  "#document()":
    topic: test_element

    "should return the owner document wrapper": (element)->
      document = element.document()

      assert.instanceOf document, this.Document
      assert.same       document._, this.document

    "should return the same wrapper all the time": (element)->
      assert.same element.document(), element.document()

  "#window()":
    topic: test_element

    "should return the owner window wrapper": (element)->
      window = element.window()

      assert.instanceOf window,          this.Window
      assert.same       window._.window, this.window.window

  "#data()":
    topic: test_element

    "should read data- attributes": (element)->
      element.attr({
        'data-false':  'false'
        'data-true':   'true'
        'data-number': '1.23'
        'data-string': '"string"'
        'data-array':  '[1,2,3]'
        'data-object': '{"boo":"hoo"}'
        'data-plain':  'plain text'
      })

      assert.equal     element.data('false'), false
      assert.equal     element.data('true'), true
      assert.equal     element.data('number'), 1.23
      assert.equal     element.data('string'), 'string'
      assert.deepEqual element.data('array'), [1,2,3]
      assert.deepEqual element.data('object'), {boo: "hoo"}
      assert.equal     element.data('plain'), 'plain text'
      assert.isNull    element.data('non-existing')

    "should read nested attributes": (element)->
      element.attr({
        'data-thing-one': '1'
        'data-thing-two': '2'
        'data-thing-three-one': '3.1'
      })

      assert.deepEqual element.data('thing'), {
        one: 1, two: 2, threeOne: 3.1
      }

    "should write data- attributes": (element)->
      assert.same  element,  element.data('string', 'string')
      assert.equal 'string', element._.getAttribute('data-string')
      assert.isTrue element['data-string'] is undefined

      assert.equal 'false',   element.data('false', false)._.getAttribute('data-false')
      assert.equal 'true',    element.data('true', true)._.getAttribute('data-true')
      assert.equal '1.23',    element.data('number', 1.23)._.getAttribute('data-number')
      assert.equal '[1,2,3]', element.data('array', [1,2,3])._.getAttribute('data-array')

    "should allow to write data as a plain hash": (element)->
      assert.same element, element.data({
        one: 1, two: 2, three: 3
      })

      assert.equal '1', element._.getAttribute('data-one')
      assert.equal '2', element._.getAttribute('data-two')
      assert.equal '3', element._.getAttribute('data-three')

    "should allow to write data as a nested hash": (element)->
      assert.same element, element.data('test', {
        'one': 1, two: 2, 'three-one': 3.1, 'threeTwo': 3.2
      })

      assert.equal '1',   element._.getAttribute('data-test-one')
      assert.equal '2',   element._.getAttribute('data-test-two')
      assert.equal '3.1', element._.getAttribute('data-test-three-one')
      assert.equal '3.2', element._.getAttribute('data-test-three-two')

    "should allow to remove data- attributes": (element)->
      element.attr {'data-something': 'something'}

      assert.equal  element, element.data('something', null)
      assert.equal '', element._.getAttribute('data-something')
