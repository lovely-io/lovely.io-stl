#
# A nice proxy to ready/write configurations
# from/into the ~/.lovelyrc file
#
# Copyright (C) 2011 Nikolay Nemshilov
#
lovelyrc = global.lovelyrc = {};
location = "#{process.env.HOME}/.lovelyrc";
options  = {}; # a local copy fo the options

#
# Making magic setters
#
# the basic idea is to provide a smart object
# that will automatically save the options into
# the ~/.lovelyrc file when the parameters
# are changed.
#
for key in ['user', 'name', 'email', 'base', 'host', 'secret', 'port']
  do (key) ->
    lovelyrc.__defineSetter__ key, (value) ->
      options[key] = value
      save_options()

    lovelyrc.__defineGetter__ key, ->
      options[key]

#
# Saves the options into the ~/.lovelyrc file
#
# @return void
#
save_options = ->
  str = "# Lovely IO config (auto-generated)\n\n"

  for key of options
      str += "#{key} = #{options[key]}\n"

  require('fs').writeFileSync(location, str)

#
# reading the current set of options if available
#
if require('path').existsSync(location)
  src = require('fs').readFileSync(location).toString()
  src.replace /(\w+)\s*=\s*([^\n]+)/g, (m, key, value) ->
      options[key] = value