#
# Automatic api-documentation generator command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

fs        = require('fs')
path      = require('path')
cwd       = process.cwd()
docs      = 'docs/'
overwrite = false


#
# Generates docs from a coffee-script file
#
# @param {String} filename
#
generate_docs_for = (filename)->
  print "   ■ ".yellow + filename


#
# Recoursively loops through the source directory
#
# @param {String} dirname
#
loop_directory_recursively = (dirname)->
  for filename in fs.readdirSync("#{cwd}/#{dirname}")
    if fs.statSync("#{cwd}/#{dirname}/#{filename}").isDirectory()
      loop_directory_recursively("#{cwd}/#{dirname}/#{filename}")
    else
      generate_docs_for("#{dirname}/#{filename}")


#
# Kicks in the documentation generator
#
exports.init = (args) ->
  docs_dir = "#{cwd}/#{docs}"

  print "Generating the API docs for the project\n".magenta

  sout  (" • ".grey + "Creating the ")+ (docs.yellow) + (" directory ".ljust(80, '.'.grey))

  if path.existsSync(docs_dir)
    sout " Already exists\n".yellow
  else
    fs.mkdirSync(docs_dir, 0o0755); sout  " Ok\n".green

  print " • ".grey + "Generating documentation"

  generate_docs_for('main.coffee') if path.existsSync("#{cwd}/main.coffee")
  loop_directory_recursively('src')

#
# Prints out the help
#
exports.help = (args) ->
  """
  Automatic API-documentation generator

  Usage:
      lovely docs

  """