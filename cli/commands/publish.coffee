#
# Updates all the locally installed packages
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Reads a file content in the current directory
#
# @param {String} filename
# @return {String} file content
#
read = (filename)->
  fs       = require('fs')
  path     = require('path')
  filename = process.cwd() + "/" + filename

  if path.existsSync(filename)
    fs.readFileSync(filename).toString()
  else
    ''


#
# Kicks in the command
#
exports.init = (args) ->
  package = require('../package')
  hosting = require('../hosting')

  sout "» Compiling the project".ljust(61)
  system "#{__dirname}/../../bin/lovely build", ->
    sout "Done\n".green

    sout "» Publishing #{lovelyrc.host}/packages/#{package.name} ".ljust(61)
    hosting.send_package
      manifest: read('package.json')
      build:    read("build/#{package.name}.js")
      demo:     read("demo.html") || read("index.html")
      documents:
        index:  read('README.md')

    sout "Done\n".green


#
# Prints out the command help
#
exports.help = (args) ->
  """
  Publishes the package on the lovely.io host

  Usage:
      lovely publish

  """