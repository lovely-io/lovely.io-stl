#
# The console commands front interface.
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

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
  str      = this + ''
  filler or= ' '
  cur_len  = str.length

  while cur_len < length
    str += if filler is ' ' then filler else filler.grey
    cur_len += 1

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
# The CLI arguments aliases and shortcuts
#
shortcuts =
  's'         : 'server'
  'b'         : 'build'
  '-h'        : 'help'
  '--help'    : 'help'
  '-v'        : 'version'
  '--version' : 'version'


#
# Kiks in the CLI commands handling
#
# @param {Array} of arguments
#
exports.init = (args) ->
  args[0] or= 'help'
  args[0] = shortcuts[args[0]] if args[0] of shortcuts

  filename = "#{__dirname}/commands/#{args[0]}.coffee"

  if require('fs').existsSync(filename)
    require(filename).init(args.slice(1))
  else
    print "Unknown command '#{args[0]}'"
