#
# Element dimensions API tests
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#
{Test,should} = require('lovely')


Test.set "/dimensions.html", """
  <html>
    <head>
      <script src="core.js"></script>
      <script src="dom.js"></script>
    </head>
    <body>
      <div id="absolute">
        <div id="relative">
          <div id="test">
            Boobs
          </div>
        </div>
      </div>
    </body>
  </html>
"""

describe "Element dimensions", ->
  $ = window = document = element = abs_el = rel_el = null

  before Test.load(module, "/dimensions.html", (dom, win)->
    $        = dom
    window   = win
    document = win.document
    element  = $('#test')[0]
    abs_el   = $('#absolute')[0]
    rel_el   = $('#relative')[0]


    # patching zombie.js while it doesn't support the stuff
    document.documentElement.clientLeft            or= 0
    document.documentElement.clientTop             or= 0
    document.documentElement.getBoundingClientRect or= -> left: 0, top: 0
    element._.getBoundingClientRect                or= -> left: 0, top: 0)


  describe "#size()", ->

    it "should return correct element's size in a hash", ->
      element.size().should.eql x: 100, y: 100

    it "should allow to set the element's size as a hash", ->
      element.size(x: 200, y: 300)
      element._.style.width.should.eql  '300px' # coz it corrects the paddings
      element._.style.height.should.eql '500px'

    it "should allow to set the element's size as two numbers", ->
      element.size(300, 400)
      element._.style.width.should.eql  '500px' # coz it corrects the paddings
      element._.style.height.should.eql '700px'

    it "should allow to specify one size only as a hash", ->
      element.style(width: '100px', height: '100px')

      element.size(x: 200)
      element._.style.width.should.eql  '300px'
      element._.style.height.should.eql '100px'

      element.size(y: 300)
      element._.style.width.should.eql  '300px'
      element._.style.height.should.eql '500px'

    it "should allow to specify the size with one value only", ->
      element.style(width: '100px', height: '100px')

      element.size(200)
      element._.style.width.should.eql  '300px'
      element._.style.height.should.eql '100px'

      element.size(null, 300)
      element._.style.width.should.eql  '300px'
      element._.style.height.should.eql '500px'

    it "should return the element itself when used as a setter", ->
      element.size(x: 100).should.equal    element
      element.size(100).should.equal       element
      element.size(null, 100).should.equal element


  describe "#scrolls()", ->

    it "should return the element's scrolling positions", ->
      element._.scrollLeft = 111
      element._.scrollTop  = 222

      element.scrolls().should.eql x: 111, y: 222

    it "should allow to set element's scrolling position as an x/y hash", ->
      element.scrolls x: 222, y: 333
      element._.scrollLeft.should.eql 222
      element._.scrollTop.should.eql  333

    it "should allow to set element's x scrolling only in as a hash", ->
      element._.scrollLeft = element._.scrollTop = 100

      element.scrolls x: 200

      element._.scrollLeft.should.eql 200
      element._.scrollTop.should.eql  100

      element.scrolls y: 300

      element._.scrollLeft.should.eql 200
      element._.scrollTop.should.eql  300

    it "should allow to set element's scrolling as a number only", ->
      element._.scrollLeft = element._.scrollTop = 100

      element.scrolls 200

      element._.scrollLeft.should.eql 200
      element._.scrollTop.should.eql  100

      element.scrolls(null, 300)

      element._.scrollLeft.should.eql 200
      element._.scrollTop.should.eql  300

    it "should return the element itself when used as a setter", ->
      element.scrolls(x: 100).should.equal    element
      element.scrolls(100).should.equal       element
      element.scrolls(null, 100).should.equal element


  describe "#position()", ->

    it "should return correct element's position", ->
      element.position().should.eql x: 0, y: 0

      element._.getBoundingClientRect = -> left: 10, top: 20

      element.position().should.eql x: 10, y: 20

    it "should allow to set element's position as a hash", ->
      element.position(x: 100, y: 200)

      element._.style.left.should.equal '100px'
      element._.style.top.should.equal  '200px'


    it "should allow to set the element's position with one entry hash", ->
      element._.style.left = element._.style.top = '0px'

      element.position x: 300

      element._.style.left.should.equal '300px'
      element._.style.top.should.equal  '0px'

      element.position y: 400

      element._.style.left.should.equal '300px'
      element._.style.top.should.equal  '400px'


    it "should allow to set the position as a number only", ->
      element._.style.left = element._.style.top = '0px'

      element.position 300

      element._.style.left.should.equal '300px'
      element._.style.top.should.equal  '0px'

      element.position null, 400

      element._.style.left.should.equal '300px'
      element._.style.top.should.equal  '400px'


    it "should return the element itself when used as a setter", ->
      element.position(x: 100).should.equal    element
      element.position(100).should.equal       element
      element.position(null, 100).should.equal element


    it "should correct the actual position for the nested positions space", ->
      element._.style.left = element._.style.top = '0px'
      abs_el._.style.position = 'absolute'
      abs_el._.getBoundingClientRect or= -> left: 100, top: 200

      element.position x: 500, y: 600

      element._.style.left.should.equal '400px'
      element._.style.top.should.equal  '400px'

  describe "#offset()", ->

    it "should return element's offset against it's offsetParent correctly", ->
      element._.getBoundingClientRect = -> left: 0, top: 0

      abs_el._.style.position = 'static'
      element.offset().should.eql x: 0, y: 0

      abs_el._.style.position = 'absolute'
      element._.getBoundingClientRect  = -> left: 200, top: 400
      abs_el._.getBoundingClientRect or= -> left: 100, top: 200
      element.offset().should.eql x: 100, y: 200

    it "should allow to set the offset as an x/y hash", ->
      element._.style.left = element._.style.top = '0px'

      element.offset(x: 55, y: 66)

      element._.style.left.should.eql '55px'
      element._.style.top.should.eql  '66px'

    it "should allow to set the offset as one entry hash", ->
      element._.style.left = element._.style.top = '0px'

      element.offset x: 300

      element._.style.left.should.equal '300px'
      element._.style.top.should.equal  '0px'

      element.offset y: 400

      element._.style.left.should.equal '300px'
      element._.style.top.should.equal  '400px'

    it "should allow to set the offset in plain numbers", ->
      element._.style.left = element._.style.top = '0px'

      element.offset 500

      element._.style.left.should.equal '500px'
      element._.style.top.should.equal  '0px'

      element.offset null, 600

      element._.style.left.should.equal '500px'
      element._.style.top.should.equal  '600px'

    it "should return the element itself when used as a setter", ->
      element.offset(x: 100).should.equal    element
      element.offset(100).should.equal       element
      element.offset(null, 100).should.equal element


  describe "#offsetParent()", ->
    before ->
      abs_el._.style.position = 'absolute'

    it "should return the correct offsetParent for an element inside of an absolutely positioned element", ->
      element.offsetParent().should.equal abs_el

    it "should return the HTML element as a fallback", ->
      abs_el.offsetParent().should.equal $('html')[0]


  describe "#overlaps()", ->
    before ->
      element.position = -> x: 100, y: 100
      element.size     = -> x: 100, y: 100

    it "should return 'true' for positions inside of the element", ->
      element.overlaps(x: 150, y: 150).should.be.true
      element.overlaps(120, 120).should.be.true

    it "should return 'false' for positions outside of the element", ->
      element.overlaps(x: 50, y: 50).should.be.false
      element.overlaps(x: 50, y: 150).should.be.false
      element.overlaps(300, 300).should.be.false
      element.overlaps(50, 300).should.be.false
      element.overlaps(300, 50).should.be.false

  describe "#index()", ->
    e1 = e2 = e3 = null

    before ->
      element._.innerHTML = """
        <div>one</div>
        <div>two</div> boo hoo
        <div>three</div>
      """

      [e1, e2, e3] = element.find('div')

    it "should return correct index for all the elements", ->
      e1.index().should.eql 0
      e2.index().should.eql 1
      e3.index().should.eql 2
