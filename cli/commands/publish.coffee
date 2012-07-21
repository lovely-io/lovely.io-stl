#
# Updates all the locally installed packages
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

#
# Reads a file content in the current directory
#
# @param {String} filename
# @return {String} file content
#
read = (filename)->
  fs       = require('fs')
  filename = process.cwd() + "/" + filename

  if fs.existsSync(filename)
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
  folder = "#{process.cwd()}/images/"
  images = {}

  if match = build.match(/('|"|\()\/?images\/.+?\1/g)
    for file in match
      file = file.substr(1, file.length - 2)
      file = file.substr(0, file.length - 1) if file[file.length-1] is "\\"
      if file = file.split('images/')[1]
        if fs.existsSync(folder + file)
          images[file] = fs.readFileSync(folder + file).toString('base64')

  return images

#
# Collects the documentation from the current directory
#
# @return {Object} documentation index
#
collect_documentation = ->
  fs   = require('fs')
  cwd  = process.cwd()
  docs =
    index:     read('README.md')
    demo:      read("demo.html") || read("index.html")
    changelog: read('CHANGELOG')

  loop_recursively = (dirname)->
    for filename in fs.readdirSync("#{cwd}/#{dirname}")
      if fs.statSync("#{cwd}/#{dirname}/#{filename}").isDirectory()
        loop_recursively("#{dirname}/#{filename}")
      else
        docs["#{dirname}/#{filename}"] = read("#{dirname}/#{filename}")

  loop_recursively('docs') if fs.existsSync("#{cwd}/docs")

  return docs



#
# Kicks in the command
#
exports.init = (args) ->
  pack    = require('../package')
  hosting = require('../hosting')

  sout "» Compiling the project".ljust(61)
  system "#{__dirname}/../../bin/lovely build", ->
    sout "Done\n".green

    build = read("build/#{pack.name}.js")

    sout "» Publishing #{lovelyrc.host}/packages/#{pack.name} ".ljust(61)
    hosting.send_package
      manifest:  read('package.json')
      build:     build
      images:    read_images(build)
      documents: collect_documentation()

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