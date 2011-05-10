#
# The magic list of Lovely IO
#
# The goal in here is to provide a quick, steady and inheritable
# JavaScript 1.7 Array like interface with some additional
# features, so that we could iterate through anything in a civilize
# maner without tempering with the JavaScript core.
#
# Copyright (C) 2011 Nikolay Nemshilov
#
List = new Class Array,
  length: 0,

  #
  # Basic constructor
  #
  # @param {mixed} iterable list
  # @return void
  #
  initialize: (items) ->
    Array_proto.splice.apply(this, [0,0].concat(A(items)))
    this

# using direct prototype extension so that it didn't
# try to overload the existing Array methods
ext List.prototype,

  #
  # Returns the first items on the list
  #
  # @return {mixed} the first item or `undefined`
  #
  first: ->
    if arguments.length is 0 then this[0]
    else this.filter.apply(this, arguments).first()

  #
  # Returns the last item on the list
  #
  # @return {mixed} the last item or `undefined`
  #
  last: ->
    if arguments.length is 0 then this[this.length - 1]
    else this.filter.apply(this, arguments).last()

  #
  # Returns the size of the list
  #
  # @return {Number} list size
  #
  size: -> this.length

  #
  # Returns a slice of the list
  #
  # @param {Number} start index
  # @param {Number} end index
  # @return {List} new slice
  #
  slice: ->
    new List(Array_proto.slice.apply(this, arguments))

  ##
  # The standard `forEaech` equivalent
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} this
  #
  each: ->
    List_call(Array_proto.forEach, this, arguments)
    this

  #
  # Maps the result of the callback function work into
  # a new {List} object
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} new
  #
  map: ->
    new List(List_call(Array_proto.map, this, arguments))

  #
  # Creates a new list that has only matching items in it
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} new
  #
  filter: ->
    new List(List_call(Array_proto.filter, this, arguments))

  #
  # Creates a new list that has no matching items in it
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} new
  #
  reject: ->
    new List(List_call(Array_reject, this, arguments))

  #
  # Creates a new list without the specified items
  #
  # @param {mixed} item
  # .....
  # @return {List} new
  #
  without: ->
    filter = A(arguments)
    this.reject (item) ->
      filter.indexOf(item) isnt -1

  #
  # Creates a new list that doesn't have 'null' and 'undefined' values
  #
  # @return {List} new
  #
  compact: ->
    this.without(null, undefined)

  #
  # Clones the list with all the internal data
  #
  # @return {List} new
  #
  clone: -> new List(A(this))

  #
  # Converts the list into an instance or {Array}
  #
  # @return {Array} new
  #
  toArray: -> A(this)

  #
  # Debugability improver
  #
  # @return {String} representation
  #
  toString: -> "#<List [#{A(this)}]>"


# private
Array_proto = Array.prototype

Array_reject = (callback, scope) ->
  Array_proto.filter.call this, ->
    !callback.apply(scope, arguments)

#
# calls the array method on the list with the arguments
# we need this wrapper to handle the calls by name feature
#
List_call = (method, list, args) ->
  # handling the calls by name
  if typeof(args[0]) is 'string'
    call_args = A(args)
    attr_name = call_args.shift()

    args = []

    if `list[0] != null` && typeof(list[0][attr_name]) is 'function'
      args = [ (item) -> item[attr_name].apply(item, call_args) ]
    else
      args = [ (item) -> item[attr_name] ]

  method.apply(list, args)