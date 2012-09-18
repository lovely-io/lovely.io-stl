#
# The `Form` unit test
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

Test.set "/form.html": """
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

describe "Form", ->
  get = (callback)->
    Test.load module, "/form.html", ($, window)->
      form = window.document.getElementById('test')
      callback(new $.Form(form), $, window, window.document)

  describe "constructor", ->

    it "should make an instance of a form", get (form, $)->
      form.should.be.instanceOf $.Form

    it "should refer to the raw dom-element correctly", get (form, $, window, document)->
      form._.should.be.same document.getElementById('test')

    it "should allow to create new forms programmatically", get (form, $)->
      form = new $.Form(action: '/some.url', method: 'post')

      form.should.be.instanceOf  $.Form
      form._.action.should.equal '/some.url'
      form._.method.should.equal 'post'

    it "should be dynamically used with the 'Element' constructor", get (form, $)->
      form = new $.Element('form', action: '/some.url')

      form.should.be.instanceOf   $.Form
      form._.tagName.should.eql   'FORM'
      form._.action.should.equal  '/some.url'

  describe "\b#elements()", ->

    it "should return the list of all the form elements", get (form, $)->
      result = form.elements()

      result.should.be.instanceOf $.NodeList
      result.map('attr', 'id').toArray().should.eql [
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

  describe "\b#inputs()", ->

    it "should return the list of input fields only", get (form, $)->
      result = form.inputs()

      result.should.be.instanceOf $.NodeList
      result.map('attr', 'id').toArray().should.eql [
        'input-name',
        'input-password',
        'input-checkbox',
        'input-textarea',
        'selectbox',
        'multiselect',
        'radio-1',
        'radio-2'
      ]

  describe '\b#input("name")', ->

    it "should return an input field by it's name", get (form, $, window, document)->
      field1 = form.input('name')
      field2 = form.input('password')

      field1.should.be.instanceOf $.Input
      field2.should.be.instanceOf $.Input

      field1._.should.equal document.getElementById('input-name')
      field2._.should.equal document.getElementById('input-password')

    it "should return 'null' of there is no such field", get (form)->
      (form.input('non-existing') is undefined).should.be.true

  describe '\b#focus()', ->

    it "should try to put the focus on the first input field", get (form)->
      field = form.inputs()[0]
      focus = false
      field.focus = ->
        focus = true
        return @

      form.focus()

      focus.should.be.true

    it "should return the form itself back to the code", get (form)->
      form.focus().should.be.same form

  describe "\b#blur()", ->

    it "should call 'blur' on every form element", get (form)->
      ids = []
      form.elements().forEach (element)->
        element.blur = -> ids.push(@_.id)

      form.blur()

      ids.should.eql [
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

    it "should return the form itself back to the code", get (form)->
      form.blur().should.equal form

  describe "\b#disable()", ->

    it "should call 'disable' on every form element", get (form)->
      ids = []
      form.elements().forEach (element)->
        element.disable = -> ids.push(@_.id)

      form.disable()

      ids.should.eql [
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

    it "should return the form itself back to the code", get (form)->
      form.disable().should.be.same form

  describe "\b#enable()", ->

    it "should call 'enable' on every form element", get (form)->
      ids = []
      form.elements().forEach (element)->
        element.enable = -> ids.push(@_.id)

      form.enable()

      ids.should.eql [
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

    it "should return the form itself back to the code", get (form)->
      form.enable().should.be.same form

  describe "\b#values()", ->

    it "should return a hash of all the form input field values", get (form)->
      form.inputs().forEach (element)->
        element.value = -> @_.value

      form.values().should.eql
        name:     'Bob'
        password: 'secret'
        text:     'Boo boo boo'
        option:   '1'
        options:  '2'


    it "should make a multi-dimensional hash when smth[smth] used", get (form, $)->
      form = new $.Form html: """
        <input name="token" value="some token" />
        <input name="person[email]" value="bobby@mountain.com" />
        <input name="person[name][first]"  value="Bobby" />
        <input name="person[name][second]" value="Mountain" />
        <input name="person[guns][]" value="Shotgun" checked="true" />
        <input name="person[guns][]" value="M16"     checked="true" />
        <input name="person[guns][]" value="Glock"   checked="true" />
      """

      form.values().should.eql
        token: 'some token'
        person:
          email: 'bobby@mountain.com'
          name:
            first:  'Bobby'
            second: 'Mountain'
          guns: [ 'Shotgun', 'M16', 'Glock' ]


  describe "\b#submit()", ->

    it "should call 'submit' on the raw form", get (form)->
      called = false
      form._.submit = -> called = true
      form.submit()
      called.should.be.true

    it "should return the form itself back to the code", get (form)->
      form.submit().should.equal form

  describe "\b#reset()", ->

    it "should call 'reset' on the raw form", get (form)->
      called = false
      form._.reset = -> called = true
      form.reset()
      called.should.be.true

    it "should return the form itself back to the code", get (form)->
      form.reset().should.be.same form

  describe 'NodeList extension', ->

    it "should create 'values()' method", get (form, $)->
      search = new $.NodeList([form])

      ('values' of search).should.be.true
      search.values().should.eql form.values()

