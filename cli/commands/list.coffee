#
# Lists the installed packages
#
# Copyright (C) 2011 Nikolay Nemshilov
#

exports.init = (args) ->
  repo = require('../repository')

  for name, versions of repo.list()
    print " #{name.ljust(16)} #{versions.join(', ').grey}"


exports.help = (args) ->
  """
  Lists installed packages

  Usage:
      lovely list

  """