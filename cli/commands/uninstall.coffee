#
# Packages uninstalling command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

exports.init = (args) ->
  lovelyrc = require('../lovelyrc')

  if args.length == 0
    print_error "You should specify the package name"

  location = lovelyrc.base
  location[location.length - 1] == '/' || (location += '/')
  location += "packages/#{args[0]}/#{args[1] || ''}"

  sout "» Uninstalling ~/.lovely/packages/#{args[0]}/#{args[1] || ''}".ljust(61)
  system "rm -rf #{location}", ->
    sout "Done\n".green


exports.help = (args) ->
  """
  Uninstalls a package

  Usage:
      lovely uninstall <package-name>[ <version>]

  """