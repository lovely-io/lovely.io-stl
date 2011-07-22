#
# This command is used to switch which version of
# a package should be used as the default one
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# searches for the latest version of the package in the directory
find_latest = (location)->
  fs       = require('fs')
  versions = []

  for entry in fs.readdirSync(location)
    if fs.statSync("#{location}/#{entry}").isDirectory()
      versions.push(entry) if entry isnt 'active'

  versions.sort()
  versions[versions.length - 1]


# the main function
exports.init = (args)->
  fs       = require('fs')
  path     = require('path')
  location = lovelyrc.base
  path     = require('path')
  package  = args.shift()


  print_error "You should specify the package name" if !package

  location[location.length - 1] == '/' || (location += '/')
  location += "packages/#{package}"

  print_error "Could't locate package '#{package}'" if !path.existsSync(location)

  version = args.shift()
  version = find_latest(location) unless version

  if !path.existsSync("#{location}/#{version}")
    print_error "Could't find version '#{version}' of '#{package}'"

  system("cd #{location}; rm -f active; ln -s #{version} active")


exports.help = (args)->
  """
  Activates a certain package version to be the default one

  Usage:
    lovely activate <package-name> [version]

  If no version is specified then the latest one will be used
  """