#
# The `Form` unit test
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load} = require('../test_helper')

server.respond "/form.html": """
<html>
  <head>
    <script src="/core.js"></script>
    <script src="/dom.js"></script>
  </head>
  <body>
    <form id="test">
      <fieldset>
        <legend>Super Duper Form</legend>
        <p>
          <label>Name</label>
          <input type='text' name='name' value='Bob' id="input-name"/>
        </p>
        <p>
          <label>Password</label>
          <input type='password' name='password' value='secret' id="input-password"/>
        </p>
        <p>
          <label>Keep me</label>
          <input type='checkbox' name='keep_me' value='1' id="input-checkbox"/>
        </p>
        <p>
          <label>Text:</label>
          <textarea name='text' id="input-textarea">Boo boo boo</textarea>
        </p>
        <p>
          <label>Kinda:</label>
          <select name='option' id="selectbox">
            <option value='0'>Zero</option>
            <option value='1' selected='true'>Alpha</option>
            <option value='2'>Bravo</option>
          </select>
        </p>
        <p>
          <label>Items:</label>
          <select name='options' multiple='true' id="multiselect">
            <option value='1'>First</option>
            <option value='2' selected='true'>Second</option>
            <option value='3' selected='true'>Third</option>
          </select>
        </p>
        <p>
          <label>Who:</label>
          <input type='radio' name='who' value='bob' id='radio-1'/>
          <input type='radio' name='who' value='nik' id='radio-2'/>
        </p>
        <p>
          <input type='submit' value='Sumbit' id="submit-button"/>
          <input type='reset'  value='Reset'  id="reset-button"/>
          <input type='button' value='Cancel' id="type-button"/>
          <input type='image'  value=''       id="type-image"/>
        </p>
      </fieldset>
    </form>
  </body>
</html>
"""

test_form = ->
  load "/form.html", this, ->
    this._form = this.document.getElementById('test')
    new this.Form(this._form)


describe "Form", module,
  "constructor":
    topic: test_form

    "should make an instance of a form": (form)->
      assert.instanceOf form, this.Form

    "should refer to the raw dom-element correctly": (form)->
      assert.same form._, this._form

    "should allow to create new forms programmatically": ->
      form = new this.Form(action: '/some.url', method: 'post')

      assert.instanceOf form, this.Form
      assert.equal      form._.action, '/some.url'
      assert.equal      form._.method, 'post'

    "should be dynamically used with the 'Element' constructor": ->
      form = new this.Element('form', action: '/some.url')
      assert.instanceOf form, this.Form
      assert.equal      form._.tagName, 'FORM'
      assert.equal      form._.action,  '/some.url'

  "#elements()":
    topic: test_form

    "should return the list of all the form elements": (form)->
      result = form.elements()

      assert.instanceOf result, this.NodeList
      assert.deepEqual  result.map('attr', 'id').toArray(), [
        'input-name',
        'input-password',
        'input-checkbox',
        'input-textarea',
        'selectbox',
        'multiselect',
        'radio-1',
        'radio-2'
        'submit-button',
        'reset-button',
        'type-button',
        'type-image'
      ]

  "#inputs()":
    topic: test_form

    "should return the list of input fields only": (form)->
      result = form.inputs()

      assert.instanceOf result, this.NodeList
      assert.deepEqual  result.map('attr', 'id').toArray(), [
        'input-name',
        'input-password',
        'input-checkbox',
        'input-textarea',
        'selectbox',
        'multiselect',
        'radio-1',
        'radio-2'
      ]

  '#input("name")':
    topic: test_form

    "should return an input field by it's name": (form)->
      field1 = form.input('name')
      field2 = form.input('password')

      assert.instanceOf field1, this.Element
      assert.instanceOf field2, this.Element

      assert.same field1._, this.document.getElementById('input-name')
      assert.same field2._, this.document.getElementById('input-password')

    "should return 'null' of there is no such field": (form)->
      assert.isUndefined form.input('non-existing')

  '#focus()':
    topic: test_form

    "should try to put the focus on the first input field": (form)->
      field = form.inputs()[0]
      focus = false
      field.focus = ->
        focus = true
        return @

      form.focus()

      assert.isTrue focus

    "should return the form itself back to the code": (form)->
      assert.same form.focus(), form

  "#blur()":
    topic: test_form

    "should call 'blur' on every form element": (form)->
      ids = []
      form.elements().forEach (element)->
        element.blur = -> ids.push(@_.id)

      form.blur()

      assert.deepEqual ids,   [
        'input-name',
        'input-password',
        'input-checkbox',
        'input-textarea',
        'selectbox',
        'multiselect',
        'radio-1',
        'radio-2'
        'submit-button',
        'reset-button',
        'type-button',
        'type-image'
      ]

    "should return the form itself back to the code": (form)->
      assert.same form.blur(), form

  "#disable()":
    topic: test_form

    "should call 'disable' on every form element": (form)->
      ids = []
      form.elements().forEach (element)->
        element.disable = -> ids.push(@_.id)

      form.disable()

      assert.deepEqual ids,   [
        'input-name',
        'input-password',
        'input-checkbox',
        'input-textarea',
        'selectbox',
        'multiselect',
        'radio-1',
        'radio-2'
        'submit-button',
        'reset-button',
        'type-button',
        'type-image'
      ]

    "should return the form itself back to the code": (form)->
      assert.same form.disable(), form

  "#enable()":
    topic: test_form

    "should call 'enable' on every form element": (form)->
      ids = []
      form.elements().forEach (element)->
        element.enable = -> ids.push(@_.id)

      form.enable()

      assert.deepEqual ids,   [
        'input-name',
        'input-password',
        'input-checkbox',
        'input-textarea',
        'selectbox',
        'multiselect',
        'radio-1',
        'radio-2'
        'submit-button',
        'reset-button',
        'type-button',
        'type-image'
      ]

    "should return the form itself back to the code": (form)->
      assert.same form.enable(), form

  "#values()":
    topic: test_form

    "should return a hash of all the form input field values": (form)->
      form.inputs().forEach (element)->
        element.value = -> @_.value

      assert.deepEqual form.values(), {
        name:     'Bob',
        password: 'secret',
        text:     'Boo boo boo',
        option:   '1',
        options:  '2'
      }

  "#submit()":
    topic: test_form

    "should call 'submit' on the raw form": (form)->
      called = false
      form._.submit = -> called = true
      form.submit()
      assert.isTrue called

    "should return the form itself back to the code": (form)->
      assert.same form.submit(), form

  "#reset()":
    topic: test_form

    "should call 'reset' on the raw form": (form)->
      called = false
      form._.reset = -> called = true
      form.reset()
      assert.isTrue called

    "should return the form itself back to the code": (form)->
      assert.same form.reset(), form

  'NodeList extension':
    topic: test_form

    "should create 'values()' method": (form)->
      search = new this.NodeList([form])

      assert.isTrue    'values' of search
      assert.deepEqual search.values(), form.values()

