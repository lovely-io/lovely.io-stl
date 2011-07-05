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
  require('fs').readFileSync(
    process.cwd() + "/" + filename
  ).toString()


#
# Kicks in the command
#
exports.init = (args) ->
  package = require('../package')
  hosting = require('../hosting')

  sout "» Compiling the project".ljust(61)
  system "../../bin/lovely build", ->
    sout "Done\n".green

    sout "» Publishing #{lovelyrc.host}/packages/#{package.name} ".ljust(61)
    hosting.send_package
      name:         package.name
      version:      package.version
      description:  package.description
      dependencies: package.dependencies
      license:      package.license
      build:        read("build/#{package.name}.js")
      readme:       read('README.md')

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