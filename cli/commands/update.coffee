#
# Updates all the locally installed packages
#
# Copyright (C) 2011 Nikolay Nemshilov
#

exports.init = (args) ->
  fs        = require('fs')
  hosting   = require('../hosting')
  repo      = require('../repository')
  location  = lovelyrc.base
  installed = []

  for name, versions of repo.list()
    installed.push(name: name, version: versions[0])

  print "» Updating installed packages"

  update_next = ->
    return if installed.length is 0

    entry = installed.shift()

    sout " ∙ ".grey + entry.name.ljust(16) + entry.version.grey + " "

    hosting.get_package entry.name, null, (pack, build)->
      if entry.version < pack.version
        repo.save(pack, build)
        sout "→".yellow + " #{pack.version}\n"
      else
        sout "✓ ".grey + "Ok\n".green

      update_next()

  update_next()



exports.help = (args) ->
  """
  Updates all the locally installed packages from the server

  Usage:
      lovely update

  """