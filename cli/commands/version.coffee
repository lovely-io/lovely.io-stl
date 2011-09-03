#
# Prints out the version number of the CLI util
#
# Copyright (C) 2011 Nikolay Nemshilov
#

exports.init = (args)->
  file = "#{__dirname}/../../package.json"
  file = require('fs').readFileSync(file)

  print JSON.parse(file.toString()).version


exports.help = (args)->
  """
  Prints out the current lovely CLI version

  Usage:
      lovely version

  """