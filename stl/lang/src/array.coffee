#
# The 'Array' unit extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
ext Array.prototype,
  #
  # Returns the size of the list
  #
  # @return {Number} list size
  #
  size: -> @length

  #
  # Checks if the list is empty
  #
  # @return {Boolean} check result
  #
  empty: -> @length is 0

  clean: ->
    @length = 0
    return @

  #
  # Clones the list with all the internal data
  #
  # @return {List} new
  #
  clone: -> new @constructor(A(@))

  #
  # Returns the first items on the list
  #
  # @return {mixed} the first item or `undefined`
  #
  first: ->
    if arguments.length is 0 then @[0]
    else @filter.apply(@, arguments).first()

  #
  # Returns the last item on the list
  #
  # @return {mixed} the last item or `undefined`
  #
  last: ->
    if arguments.length is 0 then @[@length - 1]
    else @filter.apply(@, arguments).last()

  random: ->
    if @length is 0 then undefined else @[Math.random(@.length-1)]

  includes: (item) ->
    this.indexOf(item) isnt -1

  walk: ->

  #
  # Creates a new list without the specified items
  #
  # @param {mixed} item
  # .....
  # @return {List} new
  #
  without: ->
    filter = new List(arguments)
    @reject (item) ->
      filter.includes(item)

  #
  # Creates a new list that doesn't have 'null' and 'undefined' values
  #
  # @return {List} new
  #
  compact: ->
    @without(null, undefined)

  flatten: ->
    list = new List()

    @forEach (item)->
      if isArray(item)
        list = list.concat(new List(item).flatten())
      else
        list.push(item)

    list

  uniq: -> new List().merge(@)

  merge: (list)->
    new List(list).forEach (item)->
      @.push(item) unless @includes(item)
    , @
    return @

  shuffle: `function() {
    var list = this.clone(), j, x, i = list.length;
    for (; i > 0; j = Math.random(i-1), x = list[--i], list[i] = list[j], list[j] = x) {}
    return list;}`

  sort: ->
  sortBy: ->

  reverse: ->

  min: -> Math.min.apply(Math, @)
  max: -> Math.max.apply(Math, @)
  sum: ->
    sum = 0
    sum += item for item in @
    sum