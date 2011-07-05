#
# Removes a package version from the hosting server
#

exports.init = (args)->
  if args.length isnt 2
    print_error "You should specify a package name and its version"
  else
    hosting = require('../hosting')

    sout "» Removing #{lovelyrc.host}/packages/#{args[0]}/#{args[1]}".ljust(61)
    hosting.remove_package(args[0], args[1])
    sout "Done\n".green


exports.help = (args)->
  """
  Removes a package of certain version from the hosting server

  Usage:
    lovely remove <package-name> <package-version>

  """