#
# This commands allows you to dump all the modules
# and dependencies in one flat file to be used
#
# Copyright (C) 2012 Nikolay Nemshilov
#

fs       = require('fs')
lovelyrc = require('../lovelyrc')
location = lovelyrc.base + "/packages/"

read_module = (name, modules)->
  if version = name.match(/\d+\.\d+\.\d+/)
    p_name  = name.replace(/\-\d+\.\d+\.\d+.*$/, '')
    version = version[0]
  else
    p_name  = name
    version = 'active'

  dirname = "#{location}/#{p_name}/#{version}"

  if fs.existsSync(dirname)
    print " ✓ ".green + name

    info = JSON.parse(fs.readFileSync("#{dirname}/package.json").toString())

    for key, value of info.dependencies || {}
      unless key of modules
        read_module(key + "-" + value, modules)

    modules[p_name] = fs.readFileSync("#{dirname}/build.js").toString()

  else
    print_error "Please install #{name} first"


exports.init = (args)->
  modules  = {}

  print "Resolving the dependencies".magenta

  for name in args
    read_module(name, modules)

  print "Compiling and writting the result".magenta

  unless 'core' of modules
    source = fs.readFileSync("#{location}/core/active/build.js").toString()
  else
    source = modules['core']
    delete(modules['core'])

  for name, src of modules
    source += "\n" + src

  fs.writeFileSync("lovely.js", source)

  print " » ".green + "lovely.js"



exports.help = (args)->
  """
  Dumps all the specified modules with all their dependencies
  in a static file in current directory

  Usage:
      lovely dump dom ui dialog [other module names]
      lovely dump dom-1.4.2 ui-1.1.1 [other module names]

  """