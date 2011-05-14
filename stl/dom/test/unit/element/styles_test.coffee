#
# The Element's styles handling module tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../../test_helper'

server.respond '/styles.html': """
  <html>
    <head>
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
  load "/styles.html", test, (dom)->
    # HACK: hacking the zombie over due to an issue with computed styles in there
    this.document.defaultView.getComputedStyle = (element) ->
      color: '#884422', backgroundColor: '#224488'

    new dom.Element(this.document.getElementById('test'))


describe "Element Styles", module,

  "#style":

    "\b('name')":
      topic: -> get_element(this)

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

    "\b('name1 name2...')":
      topic: -> get_element(this)

      "should read several styles into a hash": (element) ->
        element.style margin: '22px', padding: '23px'

        assert.deepEqual element.style('margin padding'),
          margin: '22px', padding: '23px'

      "should support both camelcased and dashed names": (element) ->
        element.style marginLeft: '25px', paddingRight: '26px'

        assert.deepEqual element.style('margin-left paddingRight'),
          marginLeft: '25px', paddingRight: '26px'


    "\b('name', 'value')":
      topic: -> get_element(this)

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
      topic: -> get_element(this)

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
      topic: -> get_element(this)

      "should parse all the styles out of the string": (element) ->
        element.style 'margin: 30px; padding-right: 20px; '

        assert.equal element._.style.margin,       '30px'
        assert.equal element._.style.paddingRight, '20px'

      "should return the element reference back": (element) ->
        assert.same element.style('margin:8px'), element

