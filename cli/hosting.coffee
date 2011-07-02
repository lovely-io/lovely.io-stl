#
# The hosting server connection interface
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
# Sends the package create/update request to the server
#
exports.send_package = (params)->
  post "/packages.json", package: params