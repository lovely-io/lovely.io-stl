#
# The new project generator tool
#
# Copyright (C) 2011 Nikolay Nemshilov
#
fs   = require('fs')
path = require('path')

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
  use_coffee   = args.indexOf('--js')     == -1
  use_stylus   = args.indexOf('--stylus') != -1
  use_sass     = !use_stylus && args.indexOf('--css') == -1
  placeholders =
    projectname: projectname,
    year:        new Date().getFullYear(),
    username:    lovelyrc.name || "Vasily Pupkin"

  print "Creating directory: #{projectname}"
  fs.mkdirSync(directory, 0755)

  # just checking if the file should be copied over
  suitable = (filename) ->
    ((use_coffee and filename != 'main.js')      or
    (!use_coffee and filename != 'main.coffee')) and
    ((use_stylus and filename != 'main.css' and filename != 'main.sass') or
    (!use_stylus and filename != 'main.styl'))   and
    ((use_sass   and filename != 'main.css' and filename != 'main.styl') or
    (!use_sass   and filename != 'main.sass'))

  for filename in fs.readdirSync(project_tpl)
    if suitable(filename)
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
    [a-z0-9\-]+   # should hase only alpha-numberic symbols
    [a-z0-9]$     # end with a letter or a number
  ///

  project_name = args.shift()

  if !project_name
    print_error "You have to specify the project name"

  if !name_re.test(project_name)
    print_error "Project name should match: " + name_re.toString().yellow

  if path.existsSync("#{process.cwd()}/#{project_name}")
    print_error "Directory already exists"

  generate(project_name, args)



exports.help = (args) ->
  """
  Generates a standard LovelyIO module project

  Usage:
      lovely new <project-name>

  Options:
      --js         use JavaScript for scripting
      --css        use CSS for styles
      --stylus     use Stylus for styles

  """