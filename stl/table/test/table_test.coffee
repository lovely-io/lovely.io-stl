#
# Project's main unit test
#
# Copyright (C) 2013 Nikolay Nemshilov
#
{Test, should} = require('lovely')

Test.set "/table.html": """
<html>
  <head>
    <script src="core.js"></script>
    <script src="table.js"></script>
  </head>
  <body>
    <table id="test">
      <thead>
        <tr>
          <th data-sort="name">Name</th>
          <th data-sort="osom">Osomeness</th>
        </tr>
      </thead>
      <tbody>
        <tr><td>lovely.io</td><td>10</td></tr>
        <tr><td>right.js</td><td>8</td></tr>
        <tr><td>jQuery</td><td>1</td></tr>
      </tbody>
      <tfoot>
        <tr><td>Total:</td><td>19</td></tr>
      </tfoot>
    </table>
  </body>
</html>
"""

assert_sorts = (table, column, index, result)->
  table.sort(column, index)
  table = table.text().replace(/(jquery|right|lovely)/ig, "\n$1").replace(/\s*?\n\s*/g, "\n").trim()
  table.should.eql """
  Name
  Osomeness
  #{result}
  Total:19
  """

describe "Table", ->
  Table = window = document = $ = table = null

  before Test.load "/table.html", (build, win)->
    window   = win
    document = win.document
    $        = win.Lovely.module('dom')
    Table    = build
    table    = new Table(document.getElementById('test'))


  describe 'constructor', ->
    it "should build Table instances", ->
      t = new Table()
      t.should.be.instanceOf Table

    it "should build TABLE element", ->
      t = new Table()
      t._.tagName.should.eql 'TABLE'

    it "should bypass the options", ->
      t = new Table(id: 'my-table')
      t._.id.should.eql 'my-table'

  describe '#header', ->
    it "should return the header row", ->
      table.header()[0].should.equal $('#test thead tr')[0]

  describe '#footer', ->
    it "must return the footer row", ->
      table.footer()[0].should.equal $('#test tfoot tr')[0]

  describe '#rows', ->
    it "must return the table rows list", ->
      rows = table.rows()
      rows.length.should.equal 3

      rows[0].should.equal = $('#test tbody tr')[0]
      rows[1].should.equal = $('#test tbody tr')[1]
      rows[2].should.equal = $('#test tbody tr')[2]

  describe '#sort', ->
    describe 'by column index', ->
      it "must allow to sort by a column index", ->
        assert_sorts table, 0, undefined, """
        jQuery1
        lovely.io10
        right.js8
        """

        assert_sorts table, 1, undefined, """
        jQuery1
        right.js8
        lovely.io10
        """

      it "must allow to specify the order direction", ->
        assert_sorts table, 1, 'asc', """
        jQuery1
        right.js8
        lovely.io10
        """

        assert_sorts table, 1, 'desc', """
        lovely.io10
        right.js8
        jQuery1
        """

      it "must allow to sort by the data-sort attribute", ->
        assert_sorts table, 'name', undefined, """
        jQuery1
        lovely.io10
        right.js8
        """

        assert_sorts table, 'osom', undefined, """
        jQuery1
        right.js8
        lovely.io10
        """

      it "must allow to sort by the data-sort attribute and order", ->
        assert_sorts table, 'osom', 1, """
        jQuery1
        right.js8
        lovely.io10
        """

        assert_sorts table, 'osom', -1, """
        lovely.io10
        right.js8
        jQuery1
        """

      it 'must allow to sort by custom functions', ->
        func = (row_a, row_b)->
          a = row_a.find('td:first-of-type').text()
          b = row_b.find('td:first-of-type').text()

          if a > b then 1 else if a < b then -1 else 0

        assert_sorts table, func, undefined, """
        jQuery1
        lovely.io10
        right.js8
        """

      it "must return the table iteself back", ->
        table.sort(0).should.equal table

  describe 'auto-wrapper', ->
    it "should automatically wrap TABLE elements with $", ->
      $('#test')[0].should.be.instanceOf Table

    it "should provide the Table method from the NodeList instances", ->
      $('#test').header.should.be.a 'function'
      $('#test').footer.should.be.a 'function'
      $('#test').rows.should.be.a 'function'
      $('#test').sort.should.be.a 'function'
