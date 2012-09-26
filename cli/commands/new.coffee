#
# The new project generator tool
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
fs       = require('fs')
lovelyrc = require('../lovelyrc')

placeholders = {}

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
    projectunit: projectname.replace(/(^|-)[a-z]/g, (m)-> m.toUpperCase())
    projectfile: projectname.replace(/\-/g, '_')
    year:        new Date().getFullYear(),
    username:    lovelyrc.name || "Vasily Pupkin"


  print "Creating directory: #{projectname}"
  fs.mkdirSync(directory, 0o0755)

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

      print " - #{filename}"
      fs.writeFileSync("#{directory}/#{filename}", patch_source(source))


  print " - src/"
  fs.mkdirSync("#{directory}/src", 0o0755)

  filename = "#{placeholders.projectfile}.#{
    if use_coffee then 'coffee' else 'js'
  }"

  source = if use_coffee then """
  #
  # Project's main unit
  #
  # Copyright (C) %{year} %{username}
  #
  """ else """
  /**
   * Project's main unit
   *
   * Copyright (C) %{year} %{username}
   */
  """

  print " - src/#{filename}"
  fs.writeFileSync("#{directory}/src/#{filename}", patch_source(source))

  print " - test/"
  fs.mkdirSync("#{directory}/test", 0o0755)

  filename = "#{placeholders.projectfile}_test.#{
    if use_coffee then 'coffee' else 'js'
  }"

  source = if use_coffee then """
  #
  # Project's main unit test
  #
  # Copyright (C) %{year} %{username}
  #
  {Test, assert} = require('lovely')

  describe "%{projectunit}", ->
    %{projectunit} = window = document = null

    before Test.load module, (build, win)->
      %{projectunit} = build
      window   = win
      document = win.document

    it "should have a version", ->
      assert.ok %{projectunit}.version


  """ else """
  /**
   * Project's main unit test
   *
   * Copyright (C) %{year} %{username}
   */
  var Lovely = require('lovely');
  var Test   = Lovely.Test;
  var assert = Lovely.assert;

  describe("%{projectunit}", function() {
    var %{projectunit}, window, document;

    before(Test.load(module, function(build, win) {
      %{projectunit} = build;
      window   = win;
      document = win.document;
    }));

    it("should have a version number", function() {
      assert.ok(%{projectunit}.version);
    });
  });

  """

  print " - test/#{filename}"
  fs.writeFileSync("#{directory}/test/#{filename}", patch_source(source))

  print " - build/"
  fs.mkdirSync("#{directory}/build", 0o0755)


# fills in all the placeholders
patch_source = (source)->
  for key of placeholders
    source = source.replace(
      new RegExp('%\\{'+ key + '\\}', 'g'), placeholders[key])

  source


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

  if fs.existsSync("#{process.cwd()}/#{project_name}")
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