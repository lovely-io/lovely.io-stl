#
# Completely uninstalls all the Lovely IO files
#
# Copyright (C) 2011 Nikolay Nemshilov
#


exports.init = (args) ->
  print "Removing: ~/.lovely/"
  system 'rm -rf ~/.lovely'

  print "Removing: ~/.lovelyrc"
  system 'rm -rf ~/.lovelyrc'

  print "» " + "Done".green


exports.help = (args) ->
  """
  Removes all the LovelyIO infrastructure from your disk

  Usage:
      lovely implode

  """