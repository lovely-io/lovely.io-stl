#
# Updates all the locally installed packages
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Makes a POST request to the lovelyrc.host
# in order to create/update a package
#
# @param {String} url addres (relative)
# @param {Object} data
#
post = (path, params)->
  url = require('url').parse(lovelyrc.host)

  options =
    host:   url.hostname
    port:   url.port
    path:   path
    method: 'POST'

  request = require('http').request options, (response)->
    response.setEncoding('utf8')

    response.on 'data', (data)->
      try
        data = JSON.parse(data)

        if data.errors
          print "ERROR: ".red + "request validation failed".grey

          for key, errors of data.errors
            errors = [errors] if typeof(errors) is 'string'
            for message in errors
              print "  #{key} #{message}".yellow

        else if data.url
          print "SUCCESS! ".green + "#{data.url}".grey

      catch e
        print_error "something wrong with the server"

  request.on 'error', (error)->
    print_error error.message


  data = "auth_token=#{encodeURIComponent(lovelyrc.auth)}"

  for key, value of params
    if typeof(value) is 'object'
      for name, string of value
        data += "&#{encodeURIComponent(key+'['+name+']')}=#{encodeURIComponent(string)}"
    else
      data += "&#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"

  request.write(data)
  request.end()


#
# Reads a file content in the current directory
#
# @param {String} filename
# @return {String} file content
#
read = (filename)->
  require('fs').readFileSync(
    process.cwd() + "/" + filename
  ).toString()


#
# Kicks in the command
#
exports.init = (args) ->
  source  = require('../source')
  package = require('../package')

  system "../../bin/lovely build", ->
    post "/packages.json",
      package:
        name:        package.name
        version:     package.version
        description: package.description
        build:       read("build/#{package.name}.js")
        readme:      read('README.md')


#
# Prints out the command help
#
exports.help = (args) ->
  """
  Publishes the package on the lovely.io host

  Usage:
      lovely publish

  """