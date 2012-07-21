#
# Package, local building command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
exports.init = (args) ->
  fs       = require('fs')
  source   = require('../source')
  location = process.cwd()
  pack     = require('../package')

  location +=  "/build/"
  fs.existsSync(location) || fs.mkdirSync(location, 0o0755)

  location += pack.name;
  fs.writeFileSync(location + "-src.js", source.compile())
  fs.writeFileSync(location + ".js",     source.minify())

  system("gzip -c #{location}.js > #{location}.js.gz")

  print "» Compiling: #{pack.name}".ljust(32) + " Done".green


exports.help = (args) ->
  """
  Builds and minifies the source code in a single file

  Usage:
      lovely build

  """