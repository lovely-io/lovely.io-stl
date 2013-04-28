#
# The Element's styles handling module tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')

Test.set '/styles.html': """
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

describe "Element Styles", ->
  $ = element = window = document = null

  before Test.load '/styles.html', (dom, win)->
    $        = dom
    window   = win
    document = win.document
    element  = new $.Element(document.getElementById('test'))

  describe "#style", ->

    describe "\b('name')", ->

      it "should read computed styles by name", ->
        element.style('color').should.equal '#884422'

      it "should read local styles by name", ->
        element._.style.margin = '10px'
        element.style('margin').should.equal '10px'

      it "should work with camelCased style names", ->
        element.style('backgroundColor').should.equal '#224488'

      it "should work with dash-ed style names", ->
        element.style('background-color').should.equal '#224488'

      it "should read the 'float' styles correctly", ->
        element._.style.cssFloat = 'right'
        element.style('float').should.equal 'right'

    describe "\b('name1,name2...')", ->

      it "should read several styles into a hash", ->
        element.style margin: '22px', padding: '23px'

        element.style('margin,padding').should.eql
          margin: '22px', padding: '23px'

      it "should support both camelcased and dashed names", ->
        element.style marginLeft: '25px', paddingRight: '26px'

        element.style('margin-left,paddingRight').should.eql
          marginLeft: '25px', paddingRight: '26px'


   describe "\b('name', 'value')", ->

     it "should allow to set the styles", ->
       element.style('margin', '10px')
       element._.style.margin.should.equal '10px'

     it "should accept camelCased names", ->
       element.style('borderWidth', '2px')
       element._.style.borderWidth.should.equal '2px'

     it "should accept dash-ed names", ->
       element.style('border-width', '4px')
       element._.style.borderWidth.should.equal '4px'

     it "should return the element reference back", ->
       element.style('margin', '4px').should.equal element

     it "should convert 'float' to 'cssFloat'", ->
       element.style('float', 'left')
       element._.style.cssFloat.should.equal 'left'

   describe "\b(name1: 'value1', name2: 'value2')", ->

     it "should set all the styles from a hash", ->
       element.style
         margin:         '10px'
         borderWidth:    '4px'

       element._.style.margin.should.equal      '10px'
       element._.style.borderWidth.should.equal '4px'

     it "should convert dashed names into camelCased", ->
       element.style 'padding-left': '40px'

       element._.style.paddingLeft.should.equal '40px'

     it "should return the element reference back", ->
       element.style(margin: '20px').should.equal element

   describe "\b('name1:value1; name2:value2')", ->

     it "should parse all the styles out of the string", ->
       element.style 'margin: 30px; padding-right: 20px; '

       element._.style.margin.should.equal       '30px'
       element._.style.paddingRight.should.equal '20px'

     it "should return the element reference back", ->
       element.style('margin:8px').should.equal element



  describe "#getClass()", ->

    it "should return the element's className property", ->
      element._.className = 'test1 test2'
      element.getClass().should.equal 'test1 test2'

  describe "#setClass('name')", ->

    it "should set the entire 'className' property", ->
      element.setClass('test3 test4')
      element._.className.should.equal 'test3 test4'

    it "should return the element back", ->
      element.setClass('one two').should.equal element

  describe "#addClass('name')", ->

    it "should add a class name to the list", ->
      element._.className = 'one two'
      element.addClass('three')
      element._.className.should.equal 'one two three'

    it "should not duplicate existing classes", ->
      element._.className = 'one two three'
      element.addClass('two')
      element._.className.should.equal 'one two three'

    it "should return the element itself back", ->
      element.addClass('boo').should.equal element

    it "should allow to set several classes", ->
      element._.className = 'one two'
      element.addClass 'two three'
      element._.className.should.equal 'one two three'

  describe "#removeClass('name')", ->

    it "should remove classes from the list", ->
      element._.className = 'one two three'
      element.removeClass('two')
      element._.className.should.equal 'one three'

    it "should not leave trailing spaces", ->
      element._.className = 'one two three'
      element.removeClass 'one'
      element.removeClass 'three'
      element._.className.should.equal 'two'

    it "should return the element itself back", ->
      element.removeClass('boo').should.equal element

    it "should allow to remove several classes", ->
      element._.className = 'one two three'
      element.removeClass 'one three'
      element._.className.should.equal 'two'

  describe "#toggleClass('name')", ->

    it "should add a class name when it is not on the list", ->
      element._.className = 'one'
      element.toggleClass 'two'
      element._.className.should.equal 'one two'

    it "should remove class when it is on the list", ->
      element._.className = 'one two'
      element.toggleClass 'two'
      element._.className.should.equal 'one'

    it "should return reference to the element back", ->
      element.toggleClass('boo').should.equal element
