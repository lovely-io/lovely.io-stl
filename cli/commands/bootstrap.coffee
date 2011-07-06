#
# The initial bootstraping task
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# The actual bootstrapping
#
# @param {String} optional base_dir
# @return void
#
bootstrap = (base_dir) ->
  fs       = require('fs')
  path     = require('path')
  home_dir = process.env.HOME

  base_dir or= "#{home_dir}/.lovely/"

  print "Making the base at: #{base_dir}"

  if path.existsSync(base_dir)
    print " » " + "Already exists".yellow
  else
    fs.mkdirSync(base_dir, 0755)

  print "Initial RC file at: ~/.lovelyrc"
  if path.existsSync("#{home_dir}/.lovelyrc")
    print " » " + "Already exists".yellow
  else
    lovelyrc.base = base_dir
    lovelyrc.host = 'http://cdn.lovely.io'
    lovelyrc.port = '3000'
    lovelyrc.name = 'Vasily Pupkin'


  print "Copying shared server content"
  if path.existsSync("#{base_dir}/server")
    print " » " + "Already exists".yellow
  else
    system "cp -r #{__dirname + "/../server"} #{base_dir}"


  print "Installing STL packages"
  stl_dir = "#{__dirname}/../../stl/"
  for name in fs.readdirSync(stl_dir)
    system("cd #{stl_dir + name}; #{__dirname}/../../bin/lovely install")

  print "» " + "Done".green


#
# Initializes the task
#
# @param {Array} arguments
# @return void
#
exports.init = (args) ->
  bootstrap(args[0])


# lovely help bootstrap response
exports.help = (args) ->
  """
  Bootstraps the LovelyIO infrastructure

  Usage:
      lovely bootstrap

  """