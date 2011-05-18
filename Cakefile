#
# The `cake` tasks
#
# USAGE:
#   cake taskname
#
# Copyright (C) 2011 Nikolay Nemshilov
#

task 'build', 'Build the scripts', ->
  fs   = require('fs')
  dir  = "#{__dirname}/stl/"

  for name in fs.readdirSync(dir)
    if fs.statSync(dir + name).isDirectory()
      system "cd #{dir + name}; ../../bin/lovely build"


task 'test', 'Run the tests', ->
  system 'vows stl/*/test/*/*_test.coffee stl/*/test/*/*/*_test.coffee'


task 'test:spec', 'Run the tests with the specs output', ->
  system 'vows stl/*/test/*/*_test.coffee stl/*/test/*/*/*_test.coffee --spec'


task 'check', 'Checks the source code with JSHint', ->
  fs  = require('fs')
  dir = "#{__dirname}/stl/"

  for name in fs.readdirSync(dir)
    system "cd #{dir + name}; ../../bin/lovely check"



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