#
# Packages installing command
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Common installation logic
#
# @param {Object} package
# @param {String} build
#
save_package = (package, build)->
  location = lovelyrc.base
  location[location.length - 1] == '/' || (location += '/')
  location += "packages/#{package.name}/#{package.version}"

  system "rm -rf #{location}", ->
    system "mkdir -p #{location}", ->
      fs = require('fs')

      fs.writeFileSync("#{location}/#{package.name}.js", build)
      fs.writeFileSync("#{location}/package.json", JSON.stringify(package))

      system "#{__dirname}/../../bin/lovely activate #{package.name}"


#
# Makes a local package install
#
local_install = ->
  fs      = require('fs')
  package = require('../package')

  sout "» Installing '#{package.name}' locally".ljust(61)
  system "#{__dirname}/../../bin/lovely build", ->
    save_package(
      JSON.parse(fs.readFileSync("package.json").toString()),
      fs.readFileSync("build/#{package.name}.js").toString())
    sout "Done\n".green


#
# Makes a package installation from the hosting app
#
remote_install = (args)->
  hosting = require('../hosting')

  sout "» Downloading the package from the server".ljust(61)
  hosting.get_package args[0], args[1], (package, build)->
    sout "Done\n".green

    sout "» Saving the package in ~/.lovely/packages/#{package.name} ".ljust(61)
    save_package(package, build)
    sout "Done\n".green


#
# Initalizes the command
#
exports.init = (args) ->
  package  = require('../package')

  if !args.length and !package.name
    print_error "You should specify the package name"
  else if args.length
    remote_install args
  else
    local_install()


#
# Prints out the command help
#
exports.help = (args) ->
  """
  Install a lovely package

  Usage:
      lovely install <package-name>[ <version>]

  To install your own package locally, run:
      lovely install

  from your project root directory

  """