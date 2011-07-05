#
# The console commands front interface.
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require './lovelyrc'

#
# A shortcut to make the system calls
#
# @param {String} unix command
# @param {Function} optional callback
# @return {undefined}
#
global.system = (cmd, callback) ->
  require('child_process').exec cmd, (error, stdout) ->
    throw error if error
    callback()  if callback

#
# BUG: for some reason coffee-script loosies it
#
global.print = (str) ->
  console.log(str)

#
# Puts a string into the STDOUT without breaking the line
#
global.sout = (str)->
  process.stdout.write(str)

#
# An uniformed errors printing feature
#
# NOTE: halts the process!
#
global.print_error = (str)->
  console.log("ERROR: ".red + str)
  process.exit(0)

#
# Makes a string of certain size by adding spaces at the end
#
# @param {Number} desired length
# @return {String} of that length
#
String.prototype.ljust = (length, filler) ->
  str = this + ''
  filler or= ' '

  while str.length < length
    str += filler

  str

#
# Colors and styles hackity hack
#
styles =
  white:   [37, 39]
  grey:    [90, 39]
  black:   [90, 39]
  blue:    [34, 39]
  cyan:    [36, 39]
  green:   [32, 39]
  magenta: [35, 39]
  red:     [31, 39]
  yellow:  [33, 39]

for color, nums of styles
  do (color, nums) ->
    String.prototype.__defineGetter__ color, ->
      "\u001B[#{ nums[0] }m#{this}\u001B[#{nums[1]}m"


#
# Kiks in the CLI commands handling
#
# @param {Array} of arguments
#
exports.init = (args) ->
  args[0] or= 'help'

  filename = "#{__dirname}/commands/#{args[0]}.coffee"

  if require('path').existsSync(filename)
    require(filename).init(args.slice(1))
  else
    print "Unknown command '#{args[0]}'"
