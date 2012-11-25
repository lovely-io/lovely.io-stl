#
# The `Input` unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

Test.set "/input.html", """
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
  $ = input = select = Input = window = document = null

  before Test.load module, "/input.html", (dom, win)->
    $        = dom
    Input    = $.Input
    window   = win
    document = win.document
    input    = new Input(document.getElementById('input-name'))
    select   = new Input(document.getElementById('multi-select'))


  describe "constructor", ->

    it "should create new input fields on raw elements", ->
      raw = document.getElementById('input-name')
      i   = new Input(raw)

      i.should.be.instanceOf Input
      i._.should.equal       raw

    it "should create new inputs by a tag name and options", ->
      i = new Input('textarea', name: 'boo')

      i.should.be.instanceOf Input
      i._.tagName.should.eql 'TEXTAREA'
      i._.name.should.eql    'boo'

    it "should be dynamically used with the 'Element' constructor", ->
      i = new $.Element('input', type: 'radio', name: 'boo')

      i.should.be.instanceOf Input
      i._.tagName.should.eql 'INPUT'
      i._.type.should.eql    'radio'
      i._.name.should.eql    'boo'

    it "should create input[type=text] by default", ->
      i = new Input(name: 'test')

      i.should.be.instanceOf Input
      i._.tagName.should.eql 'INPUT'
      i._.type.should.eql    'text'
      i._.name.should.eql    'test'

    it "should allow to specify the input field 'type'", ->
      i = new Input(type: 'password', name: 'test')

      i.should.be.instanceOf Input
      i._.tagName.should.eql 'INPUT'
      i._.type.should.eql    'password'
      i._.name.should.eql    'test'

    it "should create textareas with the {type: 'textarea'} option", ->
      i = new Input(type: 'textarea', name: 'test')

      i.should.be.instanceOf Input
      i._.tagName.should.eql 'TEXTAREA'
      i._.name.should.eql    'test'

    it "should create select element with the {type: 'select'} option", ->
      i = new Input(type: 'select', name: 'test')

      i.should.be.instanceOf Input
      i._.tagName.should.eql 'SELECT'
      i._.name.should.eql    'test'


  describe "\b#form()", ->

    it "should return reference to it's form object", ->
      form = input.form()

      form.should.be.instanceOf $.Form
      form._.should.be.same     document.getElementById('test-form')


  describe '\b#value()', ->
    describe "with a plain input field", ->

      it "should return the value of the field", ->
        input.value().should.eql input._.value

    describe "with a multi-select field", ->
      it "should return an array of selected values", ->
        select.value().should.eql ['two', 'three']

  describe '\b#value("data")', ->

    describe "with a plain input field", ->

      it "should assign the new value for the field", ->
        i = new Input()
        i._.value = 'old value'
        i.value('new value')
        i._.value.should.eql 'new value'

      it "should return the input field itself back to the code", ->
        input.value('another value').should.equal input

    describe "with multi-select", ->
      before ->
        input = new $.Input(type: 'select', multiple: true)
        input.html """
          <option value="one">One</option>
          <option value="two" selected="true">Two</option>
          <option value="three" selected="true">Three</option>
          <option value="four">Four</option>
        """

      it "should assign a new value as an array", ->
        input.value(['one', 'four'])

        input.value().should.eql ['one', 'four']

      it "should assign a new value as a string", ->
        input.value('two')

        input.value().should.eql ['two']

  describe '\b#focus()', ->

    it "should call the raw 'focus' method", ->
      called = false
      input._.focus = -> called = true

      input.focus()

      called.should.be.true

    it "should set the 'focused' property of the wrapper", ->
      delete(input.focused)

      input.focus()

      input.focused.should.be.true

    it "should return the input field itself back to the code", ->
      input.focus().should.equal input

  describe '\b#blur()', ->

    it "should call the raw 'blur' method", ->
      called = false
      input._.blur = -> called = true

      input.blur()

      called.should.be.true

    it "should set the 'focused' property of the wrapper to 'false'", ->
      delete(input.focused)

      input.blur()

      input.focused.should.be.false

    it "should return the input field itself back to the code", ->
      input.blur().should.equal input

  describe '#select()', ->

    it "should call the raw 'select' method", ->
      called = false
      input._.select = -> called = true

      input.select()

      called.should.be.true

    it "should set the 'focused' property of the wrapper", ->
      delete(input.focused)

      input.select()

      input.focused.should.be.true

    it "should return the input field itself back to the code", ->
      input.select().should.equal input


  describe '\b#disable()', ->

    it "should set the 'disabled' property to 'true'", ->
      input._.disabled = false
      input.disable()

      input._.disabled.should.be.true

    it "should emit the 'disable' event", ->
      emitted = false
      input.on('disable', -> emitted = true)
      input.disable()

      emitted.should.be.true

    it "should return the field itself back to the code", ->
      input.disable().should.equal input


  describe '\b#enable()', ->

    it "should set the 'disabled' property to 'false'", ->
      input._.disabled = true
      input.enable()

      input._.disabled.should.be.false

    it "should emit the 'enable' event", ->
      emitted = false
      input.on('enable', -> emitted = true)
      input.enable()

      emitted.should.be.true

    it "should return the field itself back to the code", ->
      input.enable().should.equal input

  describe '\b#disabled', ->

    describe "\b()", ->

      it "should return 'true' when a field is disabled", ->
        input._.disabled = true
        input.disabled().should.be.true

      it "should return 'false' when a field is not disabled", ->
        input._.disabled = false
        input.disabled().should.be.false

     describe "\b(value)", ->

       it "should call 'disable' when the value is 'true'", ->
         called = false
         input.disable = -> called = true; return @
         input.disabled(true)

         called.should.be.true

       it "should call 'enable' when the value is 'false'", ->
         called = false
         input.enable = -> called = true; return @
         input.disabled(false)

         called.should.be.true

       it "should return the field itself back to the code", ->
         input.disabled(true).should.equal input

  describe '\b#checked', ->

    describe "\b()", ->

      it "should return 'true' when the field is checked", ->
        input._.checked = true
        input.checked().should.be.true

      it "should return 'false' when the field is not checked", ->
        input._.checked = false
        input.checked().should.be.false

    describe "\b(value)", ->

      it "should make the field checked when called with 'true'", ->
        input._.checked = false
        input.checked(true)
        input._.checked.should.be.true

      it "should make the field unchecked when called with 'false'", ->
        input._.checked = true
        input.checked(false)
        input._.checked.should.be.false

      it "should return the input field itself back to the code", ->
        input.checked(true).should.equal input

  describe 'NodeList extension', ->

    it "should add the 'value()' method", ->
      i      = new Input(name: 'boo', value: 'hoo')
      search = new $.NodeList([i])

      search.value.should.be.a 'function'
      search.value().should.equal i.value()