#
# A nice proxy to ready/write configurations
# from/into the ~/.lovelyrc file
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

location = "#{process.env.HOME}/.lovelyrc";
options  = {}; # a local copy fo the options
params   =
  user:   'your lovely.io username'
  name:   'your full name (for code generators)'
  email:  'your email address'
  base:   'local lovely packages library location'
  host:   'the main lovely.io hosting location'
  auth:   'lovely.io authentication key'
  port:   'development server default port'
  secret: 'lovely.io authentication token'


#
# Making magic setters
#
# the basic idea is to provide a smart object
# that will automatically save the options into
# the ~/.lovelyrc file when the parameters
# are changed.
#
for key of params
  do (key) ->
    exports.__defineSetter__ key, (value) ->
      options[key] = value
      save_options()

    exports.__defineGetter__ key, ->
      options[key]

#
# Saves the options into the ~/.lovelyrc file
#
# @return void
#
save_options = ->
  str = "# Lovely IO config (auto-generated)\n\n"

  for key, value of options
      str += "#{key} = #{value} ".ljust(48) + "# #{params[key]}\n"

  require('fs').writeFileSync(location, str)


#
# reading the current set of options if available
#
if require('fs').existsSync(location)
  src = require('fs').readFileSync(location).toString()
  src.replace /(^|\n)\s*(\w+)\s*=\s*([^#\n]+)/g, (m, s, key, value) ->
    options[key] = value.trim()
