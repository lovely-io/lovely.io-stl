#
# Automatic api-documentation generator command
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

fs        = require('fs')
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
  doc_file = "#{cwd}/#{docs}#{filename.replace(/^src\//, '')}.md"
  doc_dir  = doc_file.replace(/\/[^\/]+$/, '')

  index.push(doc_file)

  sout ("   ■ ".yellow + filename + ' ').ljust(60, '.') + ' '

  return sout("Already exists\n".yellow) if fs.existsSync(doc_file)

  fs.mkdirSync(doc_dir, 0o0755) unless fs.existsSync(doc_dir)

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
      loop_directory_recursively("#{dirname}/#{filename}")
    else
      generate_docs_for("#{dirname}/#{filename}")


#
# Kicks in the documentation generator
#
exports.init = (args) ->
  docs_dir   = "#{cwd}/#{docs}"
  build_docs = ->
    sout  (" • ".grey + "Creating the "+ docs.yellow + " directory ").ljust(70, '.') + " "

    if fs.existsSync(docs_dir)
      sout "Already exists\n".yellow
    else
      fs.mkdirSync(docs_dir, 0o0755); sout  "Ok\n".green

    print " • ".grey + "Generating documentation from sources"

    generate_docs_for('main.coffee') if fs.existsSync('main.coffee')
    generate_docs_for('main.js')     if fs.existsSync('main.js')
    loop_directory_recursively('src')

    print "\nDONE".green


  print "Generating the API docs for the project\n".magenta

  if args.indexOf('rebuild') isnt -1
    sout  (" • ".grey + "Deleting the "+ docs.yellow + " directory ").ljust(70, '.') + " "
    system "rm -rf #{docs_dir}", ->
      sout  "Ok\n".green
      build_docs()
  else
    build_docs()


#
# Prints out the help
#
exports.help = (args) ->
  """
  Automatic API-documentation generator

  Usage:
      lovely docs[ rebuild]

  If you want to erase and rebuild the current docs folder call

      lovely docs rebuild

  """