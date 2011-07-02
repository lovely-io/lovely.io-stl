#
# Removes a package version from the hosting server
#

exports.init = (args)->
  if args.length isnt 2
    print_error "You should specify a package name and its version"
  else
    hosting = require('../hosting')

    hosting.remove_package(args[0], args[1])


exports.help = (args)->
  """
  Removes a package of certain version from the hosting server

  Usage:
    lovely remove <package-name> <package-version>

  """