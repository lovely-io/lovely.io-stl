#
# The `cake` tasks
#
# USAGE:
#   cake taskname
#
# Copyright (C) 2011 Nikolay Nemshilov
#

task 'build', 'Build the scripts', ->
  for dir in package_dirs()
    system "cd #{dir}; ../../bin/lovely build"


task 'test', 'Run the tests', ->
  system 'vows stl/*/test/*/*_test.coffee stl/*/test/*/*/*_test.coffee'


task 'test:spec', 'Run the tests with the specs output', ->
  system 'vows stl/*/test/*/*_test.coffee stl/*/test/*/*/*_test.coffee --spec'


task 'check', 'Checks the source code with JSHint', ->
  for dir in package_dirs()
    system "cd #{dir}; ../../bin/lovely check"


task 'publish', 'Publishes all known packages', ->
  for dir in package_dirs()
    system "cd #{dir}; ../../bin/lovely publish"


#
# A simple system-call wrapper
#
# @param {String} system cmd
# @return void
#
system = (cmd, callback) ->
  require('child_process').exec cmd, (error, stdout) ->
    if stdout || error
      console.log(stdout.trim() || error.message)

    if !error && callback
      callback()

#
# Returns a list of known package directories
#
# @return {Array} directories list
#
package_dirs = ->
  fs  = require('fs')
  dir = "#{__dirname}/stl/"

  "#{dir + name}" for name in fs.readdirSync(dir) when fs.statSync(dir + name).isDirectory()