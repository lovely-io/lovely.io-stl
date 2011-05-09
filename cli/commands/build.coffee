#
# Package, local building command
#
# Copyright (C) 2011 Nikolay Nemshilov
#
exports.init = (args) ->
  fs       = require('fs')
  path     = require('path')
  source   = require('../source')
  location = process.cwd()
  package  = require('../package').parse("#{location}/package.json")

  location +=  "/build/"
  path.existsSync(location) || fs.mkdirSync(location, 0755)

  location += package.name;
  fs.writeFileSync(location + "-src.js", source.compile())
  fs.writeFileSync(location + ".js",     source.minify())

  system("gzip -c #{location}.js > #{location}.js.gz")

  print "» Compiling: #{package.name}".ljust(32) + " Done".green


exports.help = (args) ->
  """
  Builds and minifies the source code in a single file

  Usage:
      lovely build

  """