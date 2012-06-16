#
# Automatic api-documentation generator command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

fs        = require('fs')
path      = require('path')
generate  = require('../documentation')
cwd       = process.cwd()
docs      = 'docs/'
overwrite = false
index     = []


#
# Generates docs from a coffee-script file
#
# @param {String} filename
#
generate_docs_for = (filename)->
  doc_file = "#{cwd}/#{filename.replace(/^src\//, docs)}.md"
  index.push(doc_file)

  sout ("   ■ ".yellow + filename + ' ').ljust(60, '.') + ' '

  return sout("Already exists\n".yellow) if path.existsSync(doc_file)

  content = generate.from_file("#{cwd}/#{filename}")
  return sout("Not supported yet".yellow) if content is false

  fs.writeFileSync(doc_file, content)
  sout "Ok\n".green


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

  sout  (" • ".grey + "Creating the "+ docs.yellow + " directory ").ljust(70, '.') + " "

  if path.existsSync(docs_dir)
    sout "Already exists\n".yellow
  else
    fs.mkdirSync(docs_dir, 0o0755); sout  "Ok\n".green

  print " • ".grey + "Generating documentation from sources"

  loop_directory_recursively('src')

  print "\nDONE".green

#
# Prints out the help
#
exports.help = (args) ->
  """
  Automatic API-documentation generator

  Usage:
      lovely docs

  """