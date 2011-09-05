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
