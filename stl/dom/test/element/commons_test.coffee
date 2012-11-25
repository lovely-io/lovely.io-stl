#
# The Element common methods section unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')

Test.set "/commons.html", """
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


describe 'Element Commons', ->
  $ = element = window = document = null

  before Test.load module, '/commons.html', (dom, win)->
    $        = dom
    window   = win
    document = win.document
    element  = new $.Element(document.getElementById('test'))


  describe "#attr", ->

    describe "\b('name')", ->

      it "should read a property attribute", ->
        element.attr('id').should.equal 'test'

      it "should read the 'data-test' attribute", ->
        element.attr('data-test').should.eql 'test'

      it "should return 'null' for non existing attributes", ->
        (element.attr('nonexistent') is null).should.be.true


    describe "\b('name', 'value')", ->

      it "should return the element back", ->
        element.attr('title', 'text').should.equal element

      it "should set property attributes", ->
        element.attr('title', 'new value')
        element._.title.should.eql 'new value'

      it "should set non-property attributes", ->
        element.attr('data-new', 'something')
        element._.getAttribute('data-new').should.eql 'something'


    describe "\b({name: 'value'})", ->

      it "should return the element back afterwards", ->
        element.attr(smth: 'value').should.equal element

      it "should set all the attributes from the hash", ->
        element.attr
          test_attr1: 'value1'
          test_attr2: 'value2'

        element._.getAttribute('test_attr1').should.eql 'value1'
        element._.getAttribute('test_attr2').should.eql 'value2'


    describe "\b('name', null)", ->

      it "should remove the attribute", ->
        element.attr('something', 'something')
        element.attr('something').should.eql 'something'

        element.attr('something', null)
        (element.attr('something') is null).should.be.true


  describe "#hidden()", ->

    it "should say 'true' when the element is hidden", ->
      element._.style.display = 'none'
      element.hidden().should.be.true

    it "should say 'false' when the element is visible", ->
      element._.style.display = 'block'
      element.hidden().should.be.false

  describe "#visible()", ->

    it "should say 'false' when the element is hidden", ->
      element._.style.display = 'none'
      element.visible().should.be.false

    it "should say 'true' when the element is visible", ->
      element._.style.display = 'block'
      element.visible().should.be.true

  describe "#hide()", ->

    it "should hide the element when it is visible", ->
      element._.style.display = 'block'
      element.hide()
      element._.style.display.should.eql 'none'

    it "should leave element hidden when it is not visible", ->
      element._.style.display = 'none'
      element.hide()
      element._.style.display.should.eql 'none'

    it "should return the element reference back", ->
      element.hide().should.equal element

  describe "#show()", ->

    it "should show an element if it's hidden", ->
      element._.style.display = 'none'
      element.show()
      element._.style.display.should.eql 'block'

    it "should leave a visible element visible", ->
      element._.style.display = 'inline'
      element.show()
      element._.style.display.should.eql 'inline'

    it "should return the element reference back", ->
      element.show().should.equal element

  describe "#toggle()", ->

    it "should show an element if it is hidden", ->
      element._.style.display = 'none'
      element.toggle()
      element._.style.display.should.eql 'block'

    it "should hide an element if it's visible", ->
      element._.style.display = 'block'
      element.toggle()
      element._.style.display.should.eql 'none'

    it "should return back a reference to the element",->
      element.toggle().should.equal element


  describe "#document()", ->

    it "should return the owner document wrapper", ->
      doc = element.document()

      doc.should.be.instanceOf $.Document
      doc._.should.equal       document

    it "should return the same wrapper all the time", ->
      element.document().should.equal element.document()

  describe "#window()", ->

    it "should return the owner window wrapper", ->
      win = element.window()

      win.should.be.instanceOf $.Window
      win._.should.be.same     window

  describe "#data()", ->

    it "should read data- attributes", ->
      element.attr({
        'data-false':  'false'
        'data-true':   'true'
        'data-number': '1.23'
        'data-string': '"string"'
        'data-array':  '[1,2,3]'
        'data-object': '{"boo":"hoo"}'
        'data-plain':  'plain text'
      })

      element.data('false').should.equal  false
      element.data('true').should.equal   true
      element.data('number').should.equal 1.23
      element.data('string').should.equal 'string'
      element.data('array').should.eql    [1,2,3]
      element.data('object').should.eql   {boo: "hoo"}
      element.data('plain').should.equal  'plain text'
      (element.data('non-existing') is null).should.be.true

    it "should read nested attributes", ->
      element.attr({
        'data-thing-one': '1'
        'data-thing-two': '2'
        'data-thing-three-one': '3.1'
      })

      element.data('thing').should.eql {
        one: 1, two: 2, threeOne: 3.1
      }

    it "should write data- attributes", ->
      element.data('string', 'string').should.equal element
      element._.getAttribute('data-string').should.equal 'string'
      (element['data-string'] is undefined).should.be.true

      element.data('false', false)._.getAttribute('data-false').should.equal   'false'
      element.data('true', true)._.getAttribute('data-true').should.equal      'true'
      element.data('number', 1.23)._.getAttribute('data-number').should.equal  '1.23'
      element.data('array', [1,2,3])._.getAttribute('data-array').should.equal '[1,2,3]'

    it "should allow to write data as a plain hash", ->
      element.data({
        one: 1, two: 2, three: 3
      }).should.equal element

      element._.getAttribute('data-one').should.equal   '1'
      element._.getAttribute('data-two').should.equal   '2'
      element._.getAttribute('data-three').should.equal '3'

    it "should allow to write data as a nested hash", ->
      element.data('test', {
        'one': 1, two: 2, 'three-one': 3.1, 'threeTwo': 3.2
      }).should.equal element

      element._.getAttribute('data-test-one').should.equal       '1'
      element._.getAttribute('data-test-two').should.equal       '2'
      element._.getAttribute('data-test-three-one').should.equal '3.1'
      element._.getAttribute('data-test-three-two').should.equal '3.2'

    it "should allow to remove data- attributes", ->
      element.attr {'data-something': 'something'}

      element.data('something', null).should.equal          element
      (element._.getAttribute('data-something') is null).should.be.true
