#
# The Element dom-manipulations module unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require '../../test_helper'

server.respond "/manipulations.html": """
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


test_element = ->
  load "/manipulations.html", this, (dom)->
    this.dummy = new dom.Element('div', html: 'dummy')
    new dom.Element(this.document.getElementById('test'))


describe "Element Manipulations", module,
  "#clone()":
    topic: test_element

    "should clone content and attributes": (element)->
      element._.innerHTML = "bla <b>bla</b> bla"
      clone = element.clone()

      assert.equal clone._.innerHTML, element._.innerHTML
      assert.equal clone._.id, element._.id

    "should create a new instance of Element": (element)->
      assert.instanceOf element.clone(), this.Element

    "should attach a new dom-element in it": (element)->
      assert.notSame element.clone()._, element._

  "#clear()":
    topic: test_element

    "should remove all the child elements": (element)->
      element._.innerHTML = 'some <b>content</b>'
      element.clear()

      assert.equal element._.innerHTML, ''

    "should return the element itself back": (element)->
      assert.same element.clear(), element

  "#empty()":
    topic: test_element

    "should say 'true' for an empty element": (element)->
      element._.innerHTML = ''
      assert.isTrue element.empty()

    "should say 'true' for an element with spaces only": (element)->
      element._.innerHTML = "  \n\t\n  "
      assert.isTrue element.empty()

    "should say 'false' for an element with actual content": (element)->
      element._.innerHTML = '0'
      assert.isFalse element.empty()

  "#html()":
    topic: test_element

    "should return the element's innerHTML": (element)->
      element._.innerHTML = 'some <b>content</b>'
      assert.equal element.html(), 'some <b>content</b>'

  "#html('content')":
    topic: test_element

    "should assign the new content": (element)->
      element.html('some <b>new</b> content')

      assert.equal element._.innerHTML, 'some <b>new</b> content'

    "should return element itself back": (element)->
      assert.same element.html('boo hoo'), element

  "#text()":
    topic: test_element

    "should return the element's content as a text": (element)->
      element._.innerHTML = 'some <b>inner <u>text</u></b>'
      assert.equal element.text(), 'some inner text'

    "should convert HTML escapees into normal chars": (element)->
      element._.innerHTML = 'Beevis &amp; Butthead'
      assert.equal element.text(), 'Beevis & Butthead'

  "#text('content')":
    topic: test_element

    "should assign the text and escape special chars": (element)->
      element.text('<b>Beevis</b> & <u>Butthead</u>')

      assert.equal element._.innerHTML,
        '&lt;b&gt;Beevis&lt;/b&gt; &amp; &lt;u&gt;Butthead&lt;/u&gt;'

    "should return the element itself back": (element)->
      assert.same element.text('boo hoo'), element

  "#remove()":
    topic: test_element

    "should remove the element out of it's parent element": (element)->
      element._.appendChild(this.dummy._)

      this.dummy.remove()

      assert.equal element._.innerHTML, ''

    "should return the element itself back": (element)->
      assert.same element.remove(), element

  "#replace('some content')":
    topic: test_element

    "should replace itself with a given content": (element)->
      element.clear()._.appendChild(this.dummy._)
      result = this.dummy.replace('some text')

      assert.equal element._.innerHTML, 'some text'
      assert.same  result, this.dummy


  "#update(...)":
    topic: test_element

    "should replace all the element's content": (element)->
      element._.innerHTML = 'old content'
      element.update('new content')

      assert.equal element._.innerHTML, 'new content'

    "should accept dom-wrappers as an argument": (element)->
      element.update(this.dummy)

      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should accept raw dom-elements": (element)->
      element.update(this.dummy._)

      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should accept arrays of elements": (element)->
      element.update([this.dummy])

      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should accept numbers as values": (element)->
      element.update 888
      assert.equal element._.innerHTML, '888'

    "should eval any embedded scripts": (element)->
      element.update """
        bla bla bla
        <script>var test1 = 'test-1'</script>
        trololo
        <script type="text/javascript">
          var test2 = 'test-2';
        </script>
        """

      assert.equal this.window.test1, 'test-1'
      assert.equal this.window.test2, 'test-2'

    "should return the element itself back": (element)->
      assert.same element.update('text'), element

  "#append(item, item, item)":
    topic: test_element

    "should append elements to the end": (element)->
      element._.innerHTML = '<b>boo</b>'
      element.append this.dummy, new this.Element('div', html: 'new')

      assert.equal element._.innerHTML, '<b>boo</b><div>dummy</div><div>new</div>'

    "should append strings to the end": (element)->
      element._.innerHTML = '<b>boo</b>'
      element.append '<i>eee</i>', '<u>uuu</u>'

      assert.equal element._.innerHTML, '<b>boo</b><i>eee</i><u>uuu</u>'


  "#insertTo(...)":
    topic: test_element

    "should insert it into the specified elements": (element)->
      element._.innerHTML = ''
      this.dummy.insertTo(element)
      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should insert it into raw dom-elements": (element)->
      element._.innerHTML = ''
      this.dummy.insertTo(element._)
      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should insert it into elements by '#element-id'": (element)->
      element._.innerHTML = ''
      this.dummy.insertTo('#test')

      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should return the element itself back": (element)->
      assert.same this.dummy.insertTo('#test'), this.dummy


  "#insert(...)":
    topic: test_element

    "should insert dom-wrappers": (element)->
      element.clear().insert(this.dummy)
      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should insert raw dom-elements": (element)->
      element.clear().insert(this.dummy)
      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should insert arrays of elements": (element)->
      element.clear().insert([this.dummy])
      assert.equal element._.innerHTML, '<div>dummy</div>'

    "should insert plain html content": (element)->
      element.clear().insert('<b>dummy</b>')
      assert.equal element._.innerHTML, '<b>dummy</b>'

    "should insert numerical data": (element)->
      element.clear().insert 4.44
      assert.equal element._.innerHTML, '4.44'

    "should return element itself back": (element)->
      assert.same element.insert('something'), element

    "should allow insert on top of the elements": (element)->
      element._.innerHTML = "<b>boo</b>"
      element.insert(this.dummy, 'top')

      assert.equal element._.innerHTML, '<div>dummy</div><b>boo</b>'

    "should allow to insert an element before another": (element)->
      element.clear().insert(this.dummy)
      this.dummy.insert(new this.Element('b', html: 'boo'), 'before')

      assert.equal element._.innerHTML, '<b>boo</b><div>dummy</div>'

    "should allow to insert things after the element": (element)->
      element.clear().insert(this.dummy)
      this.dummy.insert(new this.Element('b', html: 'boo'), 'after')

      assert.equal element._.innerHTML, '<div>dummy</div><b>boo</b>'

    "should allow to insert things instead of the element": (element)->
      element.clear().insert(this.dummy)
      this.dummy.insert(new this.Element('b', html: 'boo'), 'instead')

      assert.equal element._.innerHTML, '<b>boo</b>'