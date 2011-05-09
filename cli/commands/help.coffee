#
# The help manuals command
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# returns the list of available commands
commands_list = ->
  require('fs').readdirSync(__dirname).map (file) ->
    file.split('.')[0]


# kicks in the command
exports.init = (args) ->
  args[0] or= 'help'

  if commands_list().indexOf(args[0]) > -1
    print require('./'+ args[0]).help(args.slice(1))
  else
    print "Unknown command '#{args[0]}'"


# the help string
exports.help = (args) ->
  """
  Usage: lovely <command>

  Where <command> is one of:
      #{commands_list().join(', ')}

  Help usage: lovely help <command>

  """