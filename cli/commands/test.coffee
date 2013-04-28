#
# A little wrapper over mocha to help with running tests
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#

find_arg = ->
  args    = arguments[0]

  for i in [1..arguments.length]
    if args.indexOf(arguments[i]) > -1
      return args[args.indexOf(arguments[i]) + 1]

read_dir = (name, files=[])->
  fs    = require('fs')

  fs.readdirSync(name).forEach (file)->
    if fs.statSync(name + "/" + file).isDirectory()
      read_dir(name + "/" + file, files)

    else if file.substr(-8)  is '_test.js' || file.substr(-12) is '_test.coffee'
      files.push(name + "/" + file)

  return files


exports.init = (args) ->
  single   = false
  test_dir = 'test'
  fs       = require('fs')
  path     = require('path')
  Mocha    = require('mocha')
  coffee   = require('coffee-script')
  reporter = find_arg(args, '-R', '--reporter') || 'dot'
  ui       = find_arg(args, '-u', '--ui')       || 'bdd'

  mocha    = new Mocha
    ui:       ui
    reporter: reporter

  for arg in args
    if arg.substr(0,5) is 'test/'
      mocha.addFile(arg)
      single = true

  unless single
    read_dir(test_dir).forEach (file)->
      mocha.addFile(file)

  mocha.run(process.exit)



exports.help = (args)->
  """
  Runs all the mocha tests in the package

  Usage:
      lovely test
      lovely test -R nyan
      lovely test/smth_test.coffee

  Options:
    -R --reporter   name    #{'# reporter name dot,nyan,spec,etc anything mocha supports'.grey}
    -u --ui         name    #{'# ui type tdd,bdd. see mocha docs for more info'.grey}
    -m --minify             #{'# if you want to run tests agains fully minified version'.grey}

  """
