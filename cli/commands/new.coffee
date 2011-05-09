#
# The new project generator tool
#
# Copyright (C) 2011 Nikolay Nemshilov
#
fs = require('fs')

#
# Starts the new project generation
#
# @param {String} projectname
# @param {Array} the rest of the arguments
# @return void
#
generate = (projectname, args) ->
  directory    = "#{process.cwd()}/#{projectname}"
  project_tpl  = "#{__dirname}/../project_tpl"
  placeholders =
    projectname: projectname,
    year:        new Date().getFullYear(),
    username:    lovelyrc.name || "Vasily Pupkin"

  print "Creating directory: #{projectname}"
  fs.mkdirSync(directory, 0755)

  for filename in fs.readdirSync(project_tpl)
    source = fs.readFileSync("#{project_tpl}/#{filename}").toString()

    for key of placeholders
      source = source.replace(
        new RegExp('%\\{'+ key + '\\}', 'g'), placeholders[key]
      )

    print " - #{filename}"
    fs.writeFileSync("#{directory}/#{filename}", source)



exports.init = (args) ->
  name_re = ///
    ^[a-z0-9]     # it should start with a letter or a number
    [a-z0-9\-_]+  # should hase only alpha-numberic symbols
    [a-z0-9]$     # end with a letter or a number
  ///

  if args[0].match(name_re)
    try
      fs.lstatSync("#{process.cwd()}/#{args[0]}")
      print "Directory already exists".red
    catch e
      generate(args[0], args.slice(1))
  else
    print "Project name should match: ".red + name_re.toString().yellow


exports.help = (args) ->
  """
  Generates a standard LovelyIO module project

  Usage:
      lovely new <project-name>

  """