#
# Packages installing command
#
# Copyright (C) 2011 Nikolay Nemshilov
#

exports.init = (args) ->
  fs       = require('fs')
  path     = require('path')
  location = lovelyrc.base
  source   = require('../source')
  package  = require('../package')

  location[location.length - 1] == '/' || (location += '/')
  location += "#{package.name}/#{package.version}"

  system "rm -rf #{location}", ->
    system "mkdir -p #{location}", ->
      system "../../bin/lovely build", ->
        system "cp -r ./* #{location}"


exports.help = (args) ->
  """
  Install a lovely package

  Usage:
      lovely install <package-name>

  To install your own package locally, run:
      lovely install

  from your project root directory

  """