#
# String class extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
ext String.prototype,



  #
  # Checks if the string contains the given substring
  #
  # @param {String} a substring
  # @return {Boolean} check result
  #
  includes: (string) ->
    @indexOf(string) isnt -1

  #
  # Checks if this string ends with the given substring
  #
  # @param {String} a sbustring
  # @return {Boolean} check result
  #
  endsWith: (substring)->
    (@length - @lastIndexOf(substring)) is substring.length

  #
  # Checks if the string starts with the given substring
  #
  # @param {String} a substring
  # @return {Boolean} check result
  #
  startsWith: (substring)->
    @indexOf(substring) is 0

  #
  # Converts the string into an itenteger value
  #
  # @param {Integer} convertion base, default 10
  # @return {Integer|NaN} result
  #
  toInt: (base)->
    parseInt(this, if base is undefined then 10 else base)

  #
  # Converts the string into a float value
  #
  # @return {Float|NaN} result
  #
  toFloat: ->
    parseFloat(this)