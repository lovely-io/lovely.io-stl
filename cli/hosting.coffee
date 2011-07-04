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
          print "ERROR: ".red + "request failed".grey

          for key, errors of data.errors
            errors = [errors] if typeof(errors) is 'string'
            for message in errors
              print "  #{key} #{message}".yellow

        else if data.url
          print "SUCCESS! ".green + "visit #{data.url} for the result".grey

      catch e
        print_error "something wrong with the server"

  request.on 'error', (error)->
    print_error error.message


  params.auth_token = lovelyrc.auth

  request.write(to_query_string(params))
  request.end()


#
# Converts an object into a query string
#
to_query_string = (data)->

  map = (hash, prefix='')->
    result = []

    for key, value of hash
      key = if prefix is '' then key else "#{prefix}[#{key}]"

      if typeof(value) is 'object'
        if value instanceof Array
          for v in value
            result.push(["#{key}[]", v])
        else if value # assuming it's an object
          for entry in map(value, key)
            result.push(entry)

      else
        result.push([key, "#{value}"])

    result

  data = for e in map(data)
    "#{encodeURIComponent(e[0])}=#{encodeURIComponent(e[1])}"

  data.join('&')


#
# Sends the package create/update request to the server
#
exports.send_package = (params)->
  post "/packages.json", package: params


#
# Sends a request to remove a package out of the server
#
exports.remove_package = (name, version)->
  post "/packages/#{name}.json", version: version, _method: 'delete'
