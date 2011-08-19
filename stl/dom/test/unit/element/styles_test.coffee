#
# The Element's styles handling module tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load} = require('../../test_helper')

server.respond '/styles.html': """
  <html>
    <head>
      <script type="text/javascript">
        // HACK: due zombie issue with the styles
        document.documentElement.style.cssFloat = 'none';
      </script>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
      <style>
        #test {
          color: #884422;
          background-color: #224488;
        }
      </style>
    </head>
    <body>
      <div id="test"></div>
    </body>
  </html>
  """

get_element = (test) ->
  load "/styles.html", this, (dom)->
    # HACK: hacking the zombie over due to an issue with computed styles in there
    this.document.defaultView.getComputedStyle = (element) ->
      color: '#884422', backgroundColor: '#224488'

    new dom.Element(this.document.getElementById('test'))

describe "Element Styles", module,

  "#style":

    "\b('name')":
      topic: get_element

      "should read computed styles by name": (element) ->
        assert.equal element.style('color'), '#884422'

      "should read local styles by name": (element) ->
        element._.style.margin = '10px'
        assert.equal element.style('margin'), '10px'

      "should work with camelCased style names": (element) ->
        assert.equal element.style('backgroundColor'), '#224488'

      "should work with dash-ed style names": (element) ->
        assert.equal element.style('background-color'), '#224488'

      "should read the 'float' styles correctly": (element) ->
        element._.style.cssFloat = 'right'
        assert.equal element.style('float'), 'right'

    "\b('name1,name2...')":
      topic: get_element

      "should read several styles into a hash": (element) ->
        element.style margin: '22px', padding: '23px'

        assert.deepEqual element.style('margin,padding'),
          margin: '22px', padding: '23px'

      "should support both camelcased and dashed names": (element) ->
        element.style marginLeft: '25px', paddingRight: '26px'

        assert.deepEqual element.style('margin-left,paddingRight'),
          marginLeft: '25px', paddingRight: '26px'


    "\b('name', 'value')":
      topic: get_element

      "should allow to set the styles": (element) ->
        element.style('margin', '10px')
        assert.equal element._.style.margin, '10px'

      "should accept camelCased names": (element) ->
        element.style('borderWidth', '2px')
        assert.equal element._.style.borderWidth, '2px'

      "should accept dash-ed names": (element) ->
        element.style('border-width', '4px')
        assert.equal element._.style.borderWidth, '4px'

      "should return the element reference back": (element) ->
        assert.same element.style('margin', '4px'), element

      "should convert 'float' to 'cssFloat'": (element) ->
        element.style('float', 'left')
        assert.equal element._.style.cssFloat, 'left'

    "\b(name1: 'value1', name2: 'value2')":
      topic: get_element

      "should set all the styles from a hash": (element) ->
        element.style
          margin:         '10px'
          borderWidth:    '4px'

        assert.equal element._.style.margin,      '10px'
        assert.equal element._.style.borderWidth, '4px'

      "should convert dashed names into camelCased": (element) ->
        element.style 'padding-left': '40px'

        assert.equal element._.style.paddingLeft, '40px'

      "should return the element reference back": (element) ->
        assert.same element.style(margin: '20px'), element

    "\b('name1:value1; name2:value2')":
      topic: get_element

      "should parse all the styles out of the string": (element) ->
        element.style 'margin: 30px; padding-right: 20px; '

        assert.equal element._.style.margin,       '30px'
        assert.equal element._.style.paddingRight, '20px'

      "should return the element reference back": (element) ->
        assert.same element.style('margin:8px'), element



  "#getClass()":
    topic: get_element

    "should return the element's className property": (element)->
      element._.className = 'test1 test2'
      assert.equal element.getClass(), 'test1 test2'

  "#setClass('name')":
    topic: get_element

    "should set the entire 'className' property": (element)->
      element.setClass('test3 test4')
      assert.equal element._.className, 'test3 test4'

    "should return the element back": (element) ->
      assert.same element.setClass('one two'), element

  "#addClass('name')":
    topic: get_element

    "should add a class name to the list": (element) ->
      element._.className = 'one two'
      element.addClass('three')
      assert.equal element._.className, 'one two three'

    "should not duplicate existing classes": (element) ->
      element._.className = 'one two three'
      element.addClass('two')
      assert.equal element._.className, 'one two three'

    "should return the element itself back": (element) ->
      assert.same element.addClass('boo'), element

  "#removeClass('name')":
    topic: get_element

    "should remove classes from the list": (element)->
      element._.className = 'one two three'
      element.removeClass('two')
      assert.equal element._.className, 'one three'

    "should not leave trailing spaces": (element)->
      element._.className = 'one two three'
      element.removeClass 'one'
      element.removeClass 'three'
      assert.equal element._.className, 'two'

    "should return the element itself back": (element)->
      assert.same element.removeClass('boo'), element

  "#toggleClass('name')":
    topic: get_element

    "should add a class name when it is not on the list": (element)->
      element._.className = 'one'
      element.toggleClass 'two'
      assert.equal element._.className, 'one two'

    "should remove class when it is on the list": (element) ->
      element._.className = 'one two'
      element.toggleClass 'two'
      assert.equal element._.className, 'one'

    "should return reference to the element back": (element)->
      assert.same element.toggleClass('boo'), element
