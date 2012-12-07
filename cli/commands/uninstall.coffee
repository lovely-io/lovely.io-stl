#
# Packages uninstalling command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
lovelyrc = require('../lovelyrc')

uninstall = (names)->
  if args = names[0].match(/^(.+)\-(\d+\.\d+\.\d+)$/)
    args  = [args[1], args[2]]
  else
    args  = [names[0], undefined]

  names.shift()

  location = lovelyrc.base + "packages/#{args[0]}/#{args[1] || ''}"

  sout "» Uninstalling ~/.lovely/packages/#{args[0]}/#{args[1] || ''}".ljust(61)
  system "rm -rf #{location}", ->
    sout "Done\n".green
    uninstall names if names.length > 0




exports.init = (args) ->
  if args.length == 0
    print_error "You should specify the package name"
  else
    uninstall args


exports.help = (args) ->
  """
  Uninstalls a package

  Usage:
      lovely uninstall <package-name>[-<version>] ...

  """