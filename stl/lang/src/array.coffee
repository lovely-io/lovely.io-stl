#
# The 'Array' unit extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#

old_Array_sort = Array.prototype.sort

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

  #
  # Removes all the items out of the array
  #
  # @return {Array} this
  #
  clean: ->
    @length = 0
    return @

  #
  # Clones the list with all the internal data
  #
  # @return {List} new
  #
  clone: ->
    if @ instanceof core.List
      new @constructor(A(@))
    else
      A(@)

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

  #
  # Returns a random item out of the list
  #
  random: ->
    if @length is 0 then undefined else @[Math.random(@.length-1)]

  #
  # Checks if this array contains the given item
  #
  # @return {Boolean} check
  #
  includes: (item) ->
    this.indexOf(item) isnt -1

  #
  # Replaces every item in the array with the result
  # of the given callback call
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Array} this
  #
  walk: (callback, scope)->
    for item, i in @
      @[i] = callback.call(scope, item, i, @)
    return @

  #
  # Creates a new array without items that pass
  # check in the callback
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Array} new
  #
  reject: (callback, scope)->
    @filter.call @, ->
      !callback.apply scope, arguments

  #
  # Creates a new list without the specified items
  #
  # @param {mixed} item
  # .....
  # @return {List} new
  #
  without: ->
    filter = A(arguments)
    @reject (item) ->
      filter.includes(item)

  #
  # Creates a new list that doesn't have 'null' and 'undefined' values
  #
  # @return {List} new
  #
  compact: ->
    @without(null, undefined)

  #
  # Makes a flat list of items froma  multi-dimenional array
  #
  # @return {Array} new
  #
  flatten: ->
    list = if @ instanceof List then new @constructor else []

    @forEach (item)->
      if isArray(item)
        list = list.concat(item.flatten())
      else
        list.push(item)

    list

  #
  # Merges the given iterable into the current array
  #
  # @param {iterable} list
  # @return {Array} this
  #
  merge: (list)->
    A(list).forEach (item)->
      @.push(item) if @indexOf(item) is -1
    , @
    return @

  #
  # Returns a list of uniq items in the array
  #
  # @return {Array} new
  #
  uniq: ->
    list = if @ instanceof List then new @constructor else []
    list.merge(@)

  #
  # Creates a new Array that contains all the same items
  # as the original, but in a random order
  #
  # @return {Array} new
  #
  shuffle: `function() {
    var list = this.clone(), j, x, i = list.length;
    for (; i > 0; j = Math.random(i-1), x = list[--i], list[i] = list[j], list[j] = x) {}
    return list;}`

  #
  # A patch for the original {Array#sort} method to make it sort
  # numbers as numbers by default
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Array} this
  #
  sort: ->
    args = arguments
    args = [(a,b)-> if a > b then 1 else if a < b then -1 else 0] if typeof(@[0]) is 'number'
    old_Array_sort.apply(@, args)

  #
  # Returns the minimal number on the list
  #
  # @return {Number} minimal number
  #
  min: -> Math.min.apply(Math, A(@))

  #
  # Returns the maximal number on the list
  #
  # @return {Number} maximal number
  #
  max: -> Math.max.apply(Math, A(@))

  #
  # Returns the sum of all the numbers on the list
  #
  # @return {Number} sum
  #
  sum: ->
    sum = 0
    sum += item for item in @
    sum


Array.prototype.each = Array.prototype.forEach