#
# Hash is a little inheritable wrapper over Object
# to handle key-value things
#
# NOTE: Hash filters all the lists like keys/values
#       and so one by the `hasOwnProperty` check
#
# NOTE: For every instance method, there is a corresponding
#       class level method, that does the same thing but
#       works with raw javascript objects. f.e.
#
#     new Hash({a:1}).merge({b:2}) // -> new Hash(a:1, b:2)
#     Hash.merge({a:1}, {b:2})     // -> {a:1, b:2}
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Hash
  _: null # the real object reference

  #
  # basic constructor
  #
  # @param {Object} some object
  # @return void
  #
  constructor: `function Hash(object) {
    this._ = object
  }`


#
# Making `Hash.include` to automatically generate
# class level methods that will work with raw
# JavaScript objects. They are all the same
# the `Hash.prototype` ones, but they always
# take and return raw objects
#
Hash.include = (params)->
  Class.include.apply(Hash, arguments)

  for name of params
    do (name)->
      Hash[name] = ->
        args = A(arguments)
        hash = new Hash(args.shift())
        args = hash[name].apply(hash, args)
        args = args._ if args instanceof Hash
        args


# the actual Hash methods
Hash.include
  #
  # Returns the list of keys in the object
  #
  # @return Array of keys
  #
  keys: ->
    key for own key of this._

  #
  # Returns a list of values for the object
  #
  # @return Array of keys
  #
  values: ->
    value for own key, value of this._

  #
  # Chesks if the object is empty
  #
  # @return {boolean} check result
  #
  empty: ->
    for own key of this._
      return no
    yes

  #
  # Creates a complete clone of the the Hash
  #
  # @return {Hash} clone
  #
  clone: -> this.merge()

  #
  # Loops through every key-value pair in the list
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Hash} this
  #
  each: (callback, scope) ->
    object = this._

    for own key, value of object
      callback.call(scope, key, value, object)

    this

  #
  # Maps results of calls on the callback function
  # with every key-value pairs in the hash
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Array} result of calls
  #
  map: (callback, scope) ->
    object = this._; result = []

    for own key, value of object
      result.push(callback.call(scope, key, value, object))

    result

  #
  # Creates a new hash by filtering out the original one
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Hash} new
  #
  filter: (callback, scope) ->
    object = this._; data = {}

    for own key, value of object
      if callback.call(scope, key, value, object)
        data[key] = object[key]

    new Hash(data)

  #
  # Creates a new hash by rejecting some values out the original one
  #
  # @param {Function} callback
  # @param {Object} optional scope
  # @return {Hash} new
  #
  reject: (callback, scope) ->
    object = this._; data = {}

    for own key, value of object
      if !callback.call(scope, key, value, object)
        data[key] = object[key]

    new Hash(data)

  #
  # Creates a new Hash by merging the content of the current
  # hash with all the incomming ones
  #
  # @param {Object} or {Hash} to merge
  # ....
  # @return {Hash} new
  #
  merge: ->
    args = A(arguments); data = {}

    args.unshift(this._) # starting with hash own data

    while args.length > 0
      object = args.shift()
      object = object._ if object instanceof Hash

      for own key, value of object
        data[key] = if isObject(value) then Hash.merge(
          (if key of data then data[key] else {}), value
        ) else object[key]

    new Hash(data)

  #
  # Converts the Hash into a plain object
  #
  # @return {Object} plain object
  #
  toObject: -> this._
