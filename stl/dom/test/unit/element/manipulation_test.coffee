#
# The Element dom-manipulations module unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Browser} = require('../../test_helper')

Browser.respond "/manipulations.html": """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
    <body>
      <div id="test"></div>
    </body>
  </html>
  """


describe "Element Manipulations", ->
  get = (callback)->
    (done)->
      Browser.open "/manipulations.html", ($, window)->
        callback(new $.Element(window.document.getElementById('test')), $, window, window.document)
        done()

  describe "#clone()", ->

    it "should clone content and attributes", get (element)->
      element._.innerHTML = "bla <b>bla</b> bla"
      clone = element.clone()

      clone._.innerHTML.should.eql element._.innerHTML
      clone._.id.should.eql element._.id

    it "should create a new instance of Element", get (element, $)->
      element.clone().should.be.instanceOf $.Element

    it "should attach a new dom-element in it", get (element)->
      element.clone()._.should.not.equal element._

  describe "#clear()", ->

    it "should remove all the child elements", get (element)->
      element._.innerHTML = 'some <b>content</b>'
      element.clear()

      element._.innerHTML.should.equal ''

    it "should return the element itself back", get (element)->
      element.clear().should.equal element

  describe "#empty()", ->

    it "should say 'true' for an empty element", get (element)->
      element._.innerHTML = ''
      element.empty().should.be.true

    it "should say 'true' for an element with spaces only", get (element)->
      element._.innerHTML = "  \n\t\n  "
      element.empty().should.be.true

    it "should say 'false' for an element with actual content", get (element)->
      element._.innerHTML = '0'
      element.empty().should.be.false

  describe "#html()", ->

    it "should return the element's innerHTML", get (element)->
      element._.innerHTML = 'some <b>content</b>'
      element.html().should.equal 'some <b>content</b>'

  describe "#html('content')", ->

    it "should assign the new content", get (element)->
      element.html('some <b>new</b> content')

      element._.innerHTML.should.equal 'some <b>new</b> content'

    it "should return element itself back", get (element)->
      element.html('boo hoo').should.equal element

  describe "#text()", ->

    it "should return the element's content as a text", get (element)->
      element._.innerHTML = 'some <b>inner <u>text</u></b>'
      element.text().should.equal 'some inner text'

    it "should convert HTML escapees into normal chars", get (element)->
      element._.innerHTML = 'Beevis &amp; Butthead'
      element.text().should.equal 'Beevis & Butthead'

  describe "#text('content')", ->

    it "should assign the text and escape special chars", get (element)->
      element.text('<b>Beevis</b> & <u>Butthead</u>')

      element._.innerHTML.should.equal '&lt;b&gt;Beevis&lt;/b&gt; &amp; &lt;u&gt;Butthead&lt;/u&gt;'

    it "should return the element itself back", get (element)->
      element.text('boo hoo').should.equal element

  describe "#remove()", ->

    it "should remove the element out of it's parent element", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')

      element._.appendChild(dummy._)

      dummy.remove()

      element._.innerHTML.should.equal ''

    it "should return the element itself back", get (element)->
      element.remove().should.equal element

  describe "#replace('some content')", ->

    it "should replace itself with a given content", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')

      element.clear()._.appendChild(dummy._)
      result = dummy.replace('some text')

      element._.innerHTML.should.equal 'some text'
      result.should.equal dummy


  describe "#update(...)", ->

    it "should replace all the element's content", get (element)->
      element._.innerHTML = 'old content'
      element.update('new content')

      element._.innerHTML.should.equal 'new content'

    it "should accept dom-wrappers as an argument", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.update(dummy)

      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should accept raw dom-elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.update(dummy._)

      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should accept arrays of elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.update([dummy])

      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should accept numbers as values", get (element)->
      element.update 888
      element._.innerHTML.should.equal '888'

    it "should eval any embedded scripts", get (element, $, window)->
      element.update """
        bla bla bla
        <script>var test1 = 'test-1'</script>
        trololo
        <script type="text/javascript">
          var test2 = 'test-2';
        </script>
        it """

      window.test1.should.equal 'test-1'
      window.test2.should.equal 'test-2'

    it "should return the element itself back", get (element)->
      element.update('text').should.equal element

  describe "#append(item, item, item)", ->

    it "should append elements to the end", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')

      element._.innerHTML = '<b>boo</b>'
      element.append dummy, new $.Element('div', html: 'new')

      element._.innerHTML.should.equal '<b>boo</b><div>dummy</div><div>new</div>'

    it "should append strings to the end", get (element)->
      element._.innerHTML = '<b>boo</b>'
      element.append '<i>eee</i>', '<u>uuu</u>'

      element._.innerHTML.should.equal '<b>boo</b><i>eee</i><u>uuu</u>'


  describe "#insertTo(...)", ->

    it "should insert it into the specified elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element._.innerHTML = ''
      dummy.insertTo(element)
      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should insert it into raw dom-elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element._.innerHTML = ''
      dummy.insertTo(element._)
      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should insert it into elements by '#element-id'", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')

      element._.innerHTML = ''
      dummy.insertTo('#test')

      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should return the element itself back", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      dummy.insertTo('#test').should.be.same dummy


  describe "#insert(...)", ->

    it "should insert dom-wrappers", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.clear().insert(dummy)
      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should insert raw dom-elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.clear().insert(dummy)
      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should insert arrays of elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.clear().insert([dummy])
      element._.innerHTML.should.equal '<div>dummy</div>'

    it "should insert plain html content", get (element)->
      element.clear().insert('<b>dummy</b>')
      element._.innerHTML.should.equal '<b>dummy</b>'

    it "should insert numerical data", get (element)->
      element.clear().insert 4.44
      element._.innerHTML.should.equal '4.44'

    it "should return element itself back", get (element)->
      element.insert('something').should.equal element

    it "should allow insert on top of the elements", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element._.innerHTML = "<b>boo</b>"
      element.insert(dummy, 'top')

      element._.innerHTML.should.equal '<div>dummy</div><b>boo</b>'

    it "should allow to insert an element before another", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.clear().insert(dummy)
      dummy.insert(new $.Element('b', html: 'boo'), 'before')

      element._.innerHTML.should.equal '<b>boo</b><div>dummy</div>'

    it "should allow to insert things after the element", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.clear().insert(dummy)
      dummy.insert(new $.Element('b', html: 'boo'), 'after')

      element._.innerHTML.should.equal '<div>dummy</div><b>boo</b>'

    it "should allow to insert things instead of the element", get (element, $)->
      dummy = new $.Element('div', html: 'dummy')
      element.clear().insert(dummy)
      dummy.insert(new $.Element('b', html: 'boo'), 'instead')

      element._.innerHTML.should.equal '<b>boo</b>'