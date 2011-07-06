#
# Lists the installed packages
#
# Copyright (C) 2011 Nikolay Nemshilov
#

exports.init = (args) ->
  fs = require('fs')

  location = lovelyrc.base
  location[location.length - 1] == '/' || (location += '/')
  location+= "packages/"

  for name in fs.readdirSync(location)
    if fs.statSync(location + name).isDirectory()
      versions = []
      for version in fs.readdirSync(location + name)
        unless version is 'current'
          versions.push(version)

      print " #{name.ljust(16)} #{versions.sort().join(' ').grey}"


exports.help = (args) ->
  """
  Lists installed packages

  Usage:
      lovely list

  """