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
# Reading the images list
#
# @return {Object} images
#
read_images = (build)->
  fs     = require('fs')
  path   = require('path')
  folder = "#{process.cwd()}/images/"
  images = {}

  if match = build.match(/('|")\/?images\/.+?\1/g)
    for file in match
      file = file.substr(1, file.length - 2)
      if file = file.split('images/')[1]
        if path.existsSync(folder + file)
          images[file] = fs.readFileSync(folder + file).toString('base64')

  return images

#
# Kicks in the command
#
exports.init = (args) ->
  package = require('../package')
  hosting = require('../hosting')

  sout "» Compiling the project".ljust(61)
  system "#{__dirname}/../../bin/lovely build", ->
    sout "Done\n".green

    build = read("build/#{package.name}.js")

    sout "» Publishing #{lovelyrc.host}/packages/#{package.name} ".ljust(61)
    hosting.send_package
      manifest: read('package.json')
      build:    build
      images:   read_images(build)
      documents:
        index:     read('README.md')
        demo:      read("demo.html") || read("index.html")
        changelog: read('CHANGELOG')

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