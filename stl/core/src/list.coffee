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
Array_forEach = Array_proto.forEach || `function(callback, scope) {
  for (var i=0, l=this.length; i < l; i++) {
    callback.call(scope, this[i], i, this);
  }}`
Array_map     = Array_proto.map || `function(callback, scope) {
  for (var result=[], i=0, l=this.length; i < l; i++) {
    result[i] = callback.call(scope, this[i], i, this);
  }return result;}`

Array_filter  = Array_proto.filter || `function(callback, scope) {
  for (var result=[], j=0, i=0, l=this.length; i < l; i++) {
    if (callback.call(scope, this[i], i, this)) {
      result[j++] = this[i];
  }} return result;}`

Array_reject  = `function(callback, scope) {
  for (var result=[], j=0, i=0, l=this.length; i < l; i++) {
    if (!callback.call(scope, this[i], i, this)) {
      result[j++] = this[i];
  }} return result;}`

Array_some   = Array_proto.some || `function(callback, scope) {
  for (var i=0, l=this.length; i < l; i++) {
    if (callback.call(scope, this[i], i, this)) {
      return true;
  }} return false;}`

Array_every = Array_proto.every || `function(callback, scope) {
  for (var i=0, l=this.length; i < l; i++) {
    if (!callback.call(scope, this[i], i, this)) {
      return false;
  }} return true;}`

# adding those for old browsers
unless List.prototype.indexOf
  ext List.prototype,
    indexOf: `function(value, from) {
      for (var i=(from<0) ? Math.max(0, this.length+from) : from || 0, l=this.length; i < l; i++) {
        if (this[i] === value) { return i; }
      } return -1;}`
    lastIndexOf: `function(value) {
      for (var i=this.length-1; i > -1; i--) {
        if (this[i] === value) { return i; }
      } return -1;}`

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