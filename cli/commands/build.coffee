#
# Package, local building command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
exports.init = (args) ->
  fs       = require('fs')
  source   = require('../source')
  pack     = require('../package')
  vanilla  = args.indexOf('--vanilla')   isnt -1
  no_style = args.indexOf('--no-styles') isnt -1 || args.indexOf('--no-style') isnt -1
  location = process.cwd()
  filename = location + "/build/"

  sout "» Compiling: #{pack.name || ''}".ljust(32)

  fs.existsSync(filename) || fs.mkdirSync(filename, 0o0755)

  filename += pack.name || 'result';
  fs.writeFileSync(filename + "-src.js", source.compile(location, vanilla, no_style))
  fs.writeFileSync(filename + ".js",     source.minify(location, vanilla, no_style))

  system("gzip -c #{filename}.js > #{filename}.js.gz")

  print " Done".green

  if no_style # dumping styles in a separated file
    sout "» Converting styles: #{pack.name || ''}".ljust(32)

    for format in ['css', 'sass', 'styl', 'scss']
      if fs.existsSync("#{location}/main.#{format}")
        style = fs.readFileSync("#{location}/main.#{format}").toString()
        fs.writeFileSync(filename + ".css", source.style(style, format))
        print " Done".green
        break



exports.help = (args) ->
  """
  Builds and minifies the source code in a single file

  Usage:
      lovely build

  Options:
      --vanilla      vanilla (non lovely.io) module build
      --no-styles    dump styles in a separated file

  """