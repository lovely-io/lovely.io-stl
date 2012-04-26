#
# Searches for a package on the hosting server
#

exports.init = (args)->
  unless args[0]
    print_error "You should specify the package name"

  sout "» Requesting the packages index from the server".ljust(61)
  require('../hosting').get_index (index)->
    sout "Done\n".green

    for pack in index
      if pack.name.indexOf(args[0]) > -1
        print "  #{pack.name.ljust(16)} - #{pack.description}"


exports.help = (args)->
  """
  Searches for a package on the hosting server

  Usage:
    lovely search <package-name>

  """