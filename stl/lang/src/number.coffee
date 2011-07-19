#
# The Number class extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
ext Number.prototype,
  #
  # Returns an absolute value of the number
  #
  # @return {Number} absolute value
  #
  abs: -> Math.abs(@)

  #
  # Rounds the number to a nearest Integer
  # optionally you can specify how many digits
  # it should leave after the digital pointer
  #
  # @param {Integer} optional precision
  # @return {Number} result
  #
  round: (size)->
    if size is undefined then Math.round(@)
    else parseFloat(@toFixed(size))

  #
  # Rounds the number up to the nearest Integer
  #
  # @return {Number} result
  #
  ceil: -> Math.ceil(this)

  #
  # Rounds the number down to the nearest Integer
  #
  # @return {Number} result
  #
  floor: -> Math.floor(this)

  #
  # Retuns the number if it's begger thant the given
  # limit, or the limit itself otherwise
  #
  # @param {Number} lower limit
  #
  min: (value)->
    if this < value then value else this + 0

  #
  # Returns the number if it's smaller than the given
  # limit, or the limit value itself otherwise
  #
  # @param {Number} upper limit
  #
  max: (value)->
    if this > value then value else this + 0

  #
  # Executes the given callback the given number of times
  #
  # @param {Function} callback
  # @param {Object} optional callback execution scope
  # @return {Number} this
  #
  times: (callback, scope)->
    `for (var i=0; i < this; i++)
      callback.call(scope, i);`
    return @

  #
  # Calls the callback with every number from `0` to the
  # current value and returns an array of results
  #
  # @param {Function} callback
  # @param {Object} optional callback scope
  # @return {Array} result of calls
  #
  map: (callback, scope)->
    `for (var i=0, r=[]; i < this; i++)
      r.push(callback.call(scope, i));`
    return r

