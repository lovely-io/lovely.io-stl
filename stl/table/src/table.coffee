#
# Project's main unit
#
# Copyright (C) 2013 Nikolay Nemshilov
#
class Table extends Element

  #
  # Basic constructor
  #
  constructor: (options)->
    if options and options.nodeType is 1
      element = options
      options = {}
    else
      element = 'table'


    super element, options


Table.include = Element.include
Table.include

  #
  # Returns the table header rows
  #
  # @return {NodeList} header rows
  #
  header: ->
    @find('tr').filter('first', 'th')

  #
  # Returns the table footer rows
  #
  # @return {NodeList} footer rows
  #
  footer: ->
    @find('tfoot > tr')

  #
  # Returns the list of the data-rows in the table
  #
  # @return {NodeList} the tbody rows
  #
  rows: ->
    @find('tr').reject (row)->
      row.first('th') || row.parent('tfoot')

  #
  # Sort the table by the column
  #
  # @param {Integer|String|Function} sort conditions
  # @param {String|Integer} sort order
  #
  sort: (index, order)->
    rows  = @rows()

    # figuring the initial conditions
    if typeof(index) is 'number'
      th = @header().pop().find('th')[index]
    else if typeof(index) is 'string'
      th = @header().pop().first('th[data-sort="'+ index + '"]')
      index = th.index()
    else if typeof(index) is 'function'
      func = index

    # figuring the order
    order = 'desc' if order is -1 || order is false || String(order).toLowerCase() is 'desc'
    order = 'asc'  if order isnt 'desc'

    if !func
      value_for = (row)->
        td = row.find('td')[index]
        val = td.data('value') || td.text()
        if /^\d+(\.\d+)?$/.test(val) then parseFloat(val) else val

      func = (row_a, row_b)->
        a = value_for(row_a)
        b = value_for(row_b)

        if order is 'asc'
          if a > b then 1 else if a < b then -1 else 0
        else
          if a > b then -1 else if a < b then 1 else 0

    # inserting the items in place
    anchor = $(document.createElement('tr')).insertTo(rows[0], 'before')
    rows.sort(func).reverse().forEach (row)->
      anchor.insert row, 'after'
    anchor.remove()

    # painting the thead cell
    if th
      @header().find('th').removeClass('asc').removeClass('desc')
      th.addClass(order)

    @ # return table itself
