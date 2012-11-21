#
# The help manuals command
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# returns the list of available commands
commands_list = ->
  require('fs').readdirSync(__dirname).map (file) ->
    file.split('.')[0]

# returns the commands list in a batches of given length
commands_list_in_batches = (length)->
  separator = ', '
  batches   = []
  batch     = []
  commands  = commands_list()
  commands.sort()

  for name in commands
    if batch.join(separator).length > length
      batches.push(batch.join(separator))
      batch = []

    batch.push(name)

  batches.push(batch.join(separator))
  batches


# kicks in the command
exports.init = (args) ->
  args[0] or= 'help'

  if commands_list().indexOf(args[0]) > -1
    print require('./'+ args[0]).help(args.slice(1))
  else
    print_error "Unknown command '#{args[0]}'"


# the help string
exports.help = (args) ->
  """
  Usage: lovely <command>

  Where <command> is one of:
      #{commands_list_in_batches(50).join("\n    ")}

  Help usage: lovely help <command>

  """
