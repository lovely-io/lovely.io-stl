#
# The magic list of Lovely IO
#
# The goal in here is to provide a quick, steady and inheritable
# JavaScript 1.7 Array like interface with some additional
# features, so that we could iterate through anything in a civilize
# maner, without tempering with the JavaScript core.
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class List extends Array

  #
  # Basic constructor
  #
  # @param {mixed} iterable list
  # @return void
  #
  constructor: (items)->
    unless items is undefined
      Array_splice.apply(@, [0,0].concat(items))
    return @

  #
  # Returns a slice of the list
  #
  # @param {Number} start index
  # @param {Number} end index
  # @return {List} new slice
  #
  slice: ->
    new @constructor(Array_slice.apply(@, arguments))

  #
  # Array#concat like method
  #
  # @param {Array} items to add
  # @return {List} new
  #
  concat: (items)->
    new @constructor(A(@).concat(A(items)))

  ##
  # The standard `forEaech` equivalent
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} this
  #
  forEach: ->
    List_call(Array_forEach, @, arguments)
    return @

  #
  # Maps the result of the callback function work into
  # a new {List} object
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} new
  #
  map: ->
    new List(List_call(Array_map, @, arguments))

  #
  # Creates a new list that has only matching items in it
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} new
  #
  filter: ->
    new @constructor(List_call(Array_filter, @, arguments))

  #
  # Creates a new list that has no matching items in it
  #
  # @param {mixed} method name or a callback function
  # @param {mixed} scope object or the method param
  # @return {List} new
  #
  reject: ->
    new @constructor(List_call(Array_reject, @, arguments))

  #
  # Checks if some of the items on the list are kinda `true`
  #
  # @param {mixed} callback or a method name
  # @param {mixed} scope object or the method param
  # @return {Boolean} check result
  #
  some: ->
    List_call(Array_some, @, arguments)

  #
  # Checks if every item on the list are kinda `true`
  #
  # @param {mixed} callback or a method name
  # @param {mixed} scope object or the method param
  # @return {Boolean} check result
  #
  every: ->
    List_call(Array_every, @, arguments)

  #
  # Converts the list into an instance or {Array}
  #
  # @return {Array} new
  #
  toArray: -> A(@)

  #
  # Debugability improver
  #
  # @return {String} representation
  #
  toString: -> "#<List [#{A(@)}]>"


# private
Array_proto   = Array.prototype

# the rest of the standard Array methods and their replacements for old browsers
Array_slice   = Array_proto.slice
Array_splice  = Array_proto.splice
Array_forEach = Array_proto.forEach
Array_map     = Array_proto.map
Array_filter  = Array_proto.filter
Array_reject  = (callback, scope)->
  Array_filter.call @, ->
    !callback.apply scope, arguments

Array_some   = Array_proto.some
Array_every = Array_proto.every


#
# calls the array method on the list with the arguments
# we need this wrapper to handle the calls by name feature
#
List_call = (method, list, args) ->
  # handling the calls by name
  if typeof(args[0]) is 'string'
    call_args = A(args)
    attr_name = call_args.shift()

    if list.length isnt 0 and typeof(list[0][attr_name]) is 'function'
      args = [ (item) -> item[attr_name].apply(item, call_args) ]
    else
      args = [ (item) -> item[attr_name] ]

  method.apply(list, args)