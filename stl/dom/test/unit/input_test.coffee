#
# The `Input` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Browser} = require('../test_helper')

Browser.respond "/input.html": """
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

describe "Input", ->
  get_Input = (callback)->
    (done)->
      Browser.open "/input.html", ($, window)->
        callback($.Input, $, window, window.document)
        done()

  get_input = (callback)->
    (done)->
      Browser.open "/input.html", ($, window)->
        callback(new $.Input(window.document.getElementById('input-name')), $, window, window.document)
        done()

  get_multiselect = (callback)->
    (done)->
      Browser.open "/input.html", ($, window)->
        callback(new $.Input(window.document.getElementById('multi-select')), $, window, window.document)
        done()

  describe "constructor", ->

    it "should create new input fields on raw elements", get_Input (Input, $, window, document)->
      raw   = document.getElementById('input-name')
      input = new Input(raw)

      input.should.be.instanceOf Input
      input._.should.equal       raw

    it "should create new inputs by a tag name and options", get_Input (Input)->
      input = new Input('textarea', name: 'boo')

      input.should.be.instanceOf Input
      input._.tagName.should.eql 'TEXTAREA'
      input._.name.should.eql    'boo'

    it "should be dynamically used with the 'Element' constructor", get_Input (Input, $)->
      input = new $.Element('input', type: 'radio', name: 'boo')

      input.should.be.instanceOf Input
      input._.tagName.should.eql 'INPUT'
      input._.type.should.eql    'radio'
      input._.name.should.eql    'boo'

    it "should create input[type=text] by default", get_Input (Input)->
      input = new Input(name: 'test')

      input.should.be.instanceOf Input
      input._.tagName.should.eql 'INPUT'
      input._.type.should.eql    'text'
      input._.name.should.eql    'test'

    it "should allow to specify the input field 'type'", get_Input (Input)->
      input = new Input(type: 'password', name: 'test')

      input.should.be.instanceOf Input
      input._.tagName.should.eql 'INPUT'
      input._.type.should.eql    'password'
      input._.name.should.eql    'test'

    it "should create textareas with the {type: 'textarea'} option", get_Input (Input)->
      input = new Input(type: 'textarea', name: 'test')

      input.should.be.instanceOf Input
      input._.tagName.should.eql 'TEXTAREA'
      input._.name.should.eql    'test'

    it "should create select element with the {type: 'select'} option", get_Input (Input)->
      input = new Input(type: 'select', name: 'test')

      input.should.be.instanceOf Input
      input._.tagName.should.eql 'SELECT'
      input._.name.should.eql    'test'


  describe "\b#form()", ->

    it "should return reference to it's form object", get_input (input, $, window, document)->
      form = input.form()

      form.should.be.instanceOf $.Form
      form._.should.be.same     document.getElementById('test-form')


  describe '\b#value()', ->
    describe "with a plain input field", ->

      it "should return the value of the field", get_input (input)->
        input.value().should.eql input._.value

    describe "with a multi-select field", ->
      it "should return an array of selected values", get_multiselect (input)->
        input.value().should.eql ['two', 'three']

  describe '\b#value("data")', ->

    describe "with a plain input field", ->

      it "should assign the new value for the field", get_input (input)->
        input._.value = 'old value'
        input.value('new value')
        input._.value.should.eql 'new value'

      it "should return the input field itself back to the code", get_input (input)->
        input.value('another value').should.equal input

    describe "with multi-select", ->
      get = (callback)->
        (done)->
          Browser.open "/input.html", ($, window)->
            input = new $.Input(type: 'select', multiple: true)
            input.html """
              <option value="one">One</option>
              <option value="two" selected="true">Two</option>
              <option value="three" selected="true">Three</option>
              <option value="four">Four</option>
            """
            callback(input, $, window, window.document)
            done()

      it "should assign a new value as an array", get (input)->
        input.value(['one', 'four'])

        input.value().should.eql ['one', 'four']

      it "should assign a new value as a string", get (input)->
        input.value('two')

        input.value().should.eql ['two']

  describe '\b#focus()', ->

    it "should call the raw 'focus' method", get_input (input)->
      called = false
      input._.focus = -> called = true

      input.focus()

      called.should.be.true

    it "should set the 'focused' property of the wrapper", get_input (input)->
      delete(input.focused)

      input.focus()

      input.focused.should.be.true

    it "should return the input field itself back to the code", get_input (input)->
      input.focus().should.equal input

  describe '\b#blur()', ->

    it "should call the raw 'blur' method", get_input (input)->
      called = false
      input._.blur = -> called = true

      input.blur()

      called.should.be.true

    it "should set the 'focused' property of the wrapper to 'false'", get_input (input)->
      delete(input.focused)

      input.blur()

      input.focused.should.be.false

    it "should return the input field itself back to the code", get_input (input)->
      input.blur().should.equal input

  describe '#select()', ->

    it "should call the raw 'select' method", get_input (input)->
      called = false
      input._.select = -> called = true

      input.select()

      called.should.be.true

    it "should set the 'focused' property of the wrapper", get_input (input)->
      delete(input.focused)

      input.select()

      input.focused.should.be.true

    it "should return the input field itself back to the code", get_input (input)->
      input.select().should.equal input


  describe '\b#disable()', ->

    it "should set the 'disabled' property to 'true'", get_input (input)->
      input._.disabled = false
      input.disable()

      input._.disabled.should.be.true

    it "should emit the 'disable' event", get_input (input)->
      emitted = false
      input.on('disable', -> emitted = true)
      input.disable()

      emitted.should.be.true

    it "should return the field itself back to the code", get_input (input)->
      input.disable().should.equal input


  describe '\b#enable()', ->

    it "should set the 'disabled' property to 'false'", get_input (input)->
      input._.disabled = true
      input.enable()

      input._.disabled.should.be.false

    it "should emit the 'enable' event", get_input (input)->
      emitted = false
      input.on('enable', -> emitted = true)
      input.enable()

      emitted.should.be.true

    it "should return the field itself back to the code", get_input (input)->
      input.enable().should.equal input

  describe '\b#disabled', ->

    describe "\b()", ->

      it "should return 'true' when a field is disabled", get_input (input)->
        input._.disabled = true
        input.disabled().should.be.true

      it "should return 'false' when a field is not disabled", get_input (input)->
        input._.disabled = false
        input.disabled().should.be.false

     describe "\b(value)", ->

       it "should call 'disable' when the value is 'true'", get_input (input)->
         called = false
         input.disable = -> called = true; return @
         input.disabled(true)

         called.should.be.true

       it "should call 'enable' when the value is 'false'", get_input (input)->
         called = false
         input.enable = -> called = true; return @
         input.disabled(false)

         called.should.be.true

       it "should return the field itself back to the code", get_input (input)->
         input.disabled(true).should.equal input

  describe '\b#checked', ->

    describe "\b()", ->

      it "should return 'true' when the field is checked", get_input (input)->
        input._.checked = true
        input.checked().should.be.true

      it "should return 'false' when the field is not checked", get_input (input)->
        input._.checked = false
        input.checked().should.be.false

    describe "\b(value)", ->

      it "should make the field checked when called with 'true'", get_input (input)->
        input._.checked = false
        input.checked(true)
        input._.checked.should.be.true

      it "should make the field unchecked when called with 'false'", get_input (input)->
        input._.checked = true
        input.checked(false)
        input._.checked.should.be.false

      it "should return the input field itself back to the code", get_input (input)->
        input.checked(true).should.equal input

  describe 'NodeList extension', ->

    it "should add the 'value()' method", get_Input (Input, $)->
      input = new Input(name: 'boo', value: 'hoo')
      search = new $.NodeList([input])

      search.value.should.be.a 'function'
      search.value().should.equal input.value()