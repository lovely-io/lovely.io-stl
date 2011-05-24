#
# The `Input` unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load} = require('../test_helper')

server.respond "/input.html": """
<html>
  <head>
    <script src="/core.js"></script>
    <script src="/dom.js"></script>
  </head>
  <body>
    <form id="test-form" action="/some.url">
      <input type="text" name="name" id="input-name"/>

      <select id="multi-select" multiple="true">
        <option value="one">One</option>
        <option value="two" selected="true">Two</option>
        <option value="three" selected="true">Three</option>
        <option value="four">Four</option>
      </select>
    </form>
  </body>
</html>
"""

Input = ->
  load "/input.html", this, ->
    this.Input

test_input = ->
  load "/input.html", this, ->
    new this.Input(this.document.getElementById('input-name'))

test_multiselect = ->
  load "/input.html", this, ->
    new this.Input(this.document.getElementById('multi-select'))


describe "Input", module,
  "constructor":
    topic: Input

    "should create new input fields on raw elements": (Input)->
      raw   = this.document.getElementById('input-name')
      input = new Input(raw)

      assert.instanceOf input,   Input
      assert.same       input._, raw

    "should create new inputs by a tag name and options": (Input)->
      input = new Input('textarea', name: 'boo')

      assert.instanceOf input,           Input
      assert.equal      input._.tagName, 'TEXTAREA'
      assert.equal      input._.name,    'boo'

    "should be dynamically used with the 'Element' constructor": (Input)->
      input = new this.Element('input', type: 'radio', name: 'boo')

      assert.instanceOf input,           Input
      assert.equal      input._.tagName, 'INPUT'
      assert.equal      input._.type,    'radio'
      assert.equal      input._.name,    'boo'

    "should create input[type=text] by default": (Input)->
      input = new Input(name: 'test')

      assert.instanceOf input,           Input
      assert.equal      input._.tagName, 'INPUT'
      assert.equal      input._.type,    'text'
      assert.equal      input._.name,    'test'

    "should allow to specify the input field 'type'": (Input)->
      input = new Input(type: 'password', name: 'test')

      assert.instanceOf input,           Input
      assert.equal      input._.tagName, 'INPUT'
      assert.equal      input._.type,    'password'
      assert.equal      input._.name,    'test'

    "should create textareas with the {type: 'textarea'} option": (Input)->
      input = new Input(type: 'textarea', name: 'test')

      assert.instanceOf input,           Input
      assert.equal      input._.tagName, 'TEXTAREA'
      assert.equal      input._.name,    'test'

    "should create select element with the {type: 'select'} option": (Input)->
      input = new Input(type: 'select', name: 'test')

      assert.instanceOf input,           Input
      assert.equal      input._.tagName, 'SELECT'
      assert.equal      input._.name,    'test'

  "#form":
    topic: test_input

    "should return reference to it's form object": (input)->
      form = input.form()

      assert.instanceOf form,   this.Form
      assert.same       form._, this.document.getElementById('test-form')

  '#value()':
    "with a plain input field":
      topic: test_input

      "should return the value of the field": (input)->
        assert.equal input.value(), input._.value

    "with a multi-select field":
      topic: test_multiselect

      "should return an array of selected values": (input)->
        assert.deepEqual input.value(), ['two', 'three']

  '#value("data")':
    topic: Input

    "with a plain input field":
      topic: (Input)-> new Input(value: 'old value')

      "should assign the new value for the field": (input)->
        input.value('new value')
        assert.equal input._.value, 'new value'

      "should return the input field itself back to the code": (input)->
        assert.same input.value('another value'), input

    "with multi-select":
      topic: (Input)->
        input = new Input(type: 'select', multiple: true)
        input.html """
          <option value="one">One</option>
          <option value="two" selected="true">Two</option>
          <option value="three" selected="true">Three</option>
          <option value="four">Four</option>
        """

      "should assign a new value as an array": (input)->
        input.value(['one', 'four'])

        assert.deepEqual input.value(), ['one', 'four']

      "should assign a new value as a string": (input)->
        input.value('two')

        assert.deepEqual input.value(), ['two']

  '#focus()':
    topic: test_input

    "should call the raw 'focus' method": (input)->
      called = false
      input._.focus = -> called = true

      input.focus()

      assert.isTrue called

    "should set the 'focused' property of the wrapper": (input)->
      delete(input.focused)

      input.focus()

      assert.isTrue input.focused

    "should return the input field itself back to the code": (input)->
      assert.same input.focus(), input

  '#blur()':
    topic: test_input

    "should call the raw 'blur' method": (input)->
      called = false
      input._.blur = -> called = true

      input.blur()

      assert.isTrue called

    "should set the 'focused' property of the wrapper to 'false'": (input)->
      delete(input.focused)

      input.blur()

      assert.isFalse input.focused

    "should return the input field itself back to the code": (input)->
      assert.same input.blur(), input

  '#select()':
    topic: test_input

    "should call the raw 'select' method": (input)->
      called = false
      input._.select = -> called = true

      input.select()

      assert.isTrue called

    "should set the 'focused' property of the wrapper": (input)->
      delete(input.focused)

      input.select()

      assert.isTrue input.focused

    "should return the input field itself back to the code": (input)->
      assert.same input.select(), input


  '#disable()':
    topic: test_input

    "should set the 'disabled' property to 'true'": (input)->
      input._.disabled = false
      input.disable()

      assert.isTrue input._.disabled

    "should emit the 'disable' event": (input)->
      emitted = false
      input.on('disable', -> emitted = true)
      input.disable()

      assert.isTrue emitted

    "should return the field itself back to the code": (input)->
      assert.same input.disable(), input


  '#enable()':
    topic: test_input

    "should set the 'disabled' property to 'false'": (input)->
      input._.disabled = true
      input.enable()

      assert.isFalse input._.disabled

    "should emit the 'enable' event": (input)->
      emitted = false
      input.on('enable', -> emitted = true)
      input.enable()

      assert.isTrue emitted

    "should return the field itself back to the code": (input)->
      assert.same input.enable(), input

  '#disabled':
    topic: Input

    "\b()":
      topic: (Input)-> new Input(name: 'test')

      "should return 'true' when a field is disabled": (input)->
        input._.disabled = true
        assert.isTrue input.disabled()

      "should return 'false' when a field is not disabled": (input)->
        input._.disabled = false
        assert.isFalse input.disabled()

     "\b(value)":
       topic: (Input)-> new Input(name: 'test')

       "should call 'disable' when the value is 'true'": (input)->
         called = false
         input.disable = -> called = true; return @
         input.disabled(true)

         assert.isTrue called

       "should call 'enable' when the value is 'false'": (input)->
         called = false
         input.enable = -> called = true; return @
         input.disabled(false)

         assert.isTrue called

       "should return the field itself back to the code": (input)->
         assert.same input.disabled(true), input

  '#checked':
    topic: Input

    "\b()":
      topic: (Input)-> new Input(type: 'checkbox')

      "should return 'true' when the field is checked": (input)->
        input._.checked = true
        assert.isTrue input.checked()

      "should return 'false' when the field is not checked": (input)->
        input._.checked = false
        assert.isFalse input.checked()

    "\b(value)":
      topic: (Input)-> new Input(type: 'checkbox')

      "should make the field checked when called with 'true'": (input)->
        input._.checked = false
        input.checked(true)
        assert.isTrue input._.checked

      "should make the field unchecked when called with 'false'": (input)->
        input._.checked = true
        input.checked(false)
        assert.isFalse input._.checked

      "should return the input field itself back to the code": (input)->
        assert.same input.checked(true), input