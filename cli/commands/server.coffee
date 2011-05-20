#
# The package local server. It builds a user's
# package on fly alowing to effectively split it
# apart and work with it in a nice environment
#
# Copyright (C) 2011 Nikolay Nemshilov
#
exports.init = (args) ->
  fs      = require('fs')
  source  = require('../source')
  express = require('express')
  server  = express.createServer()
  port    = args[0] || lovelyrc.port || 3000
  base    = lovelyrc.base
  minify  = false

  base[base.length - 1] isnt '/' and base += '/'
  base += "packages"

  # dynamically serving the main module script
  server.get '/main.js', (req, res) ->
    src  = if minify then source.minify() else source.compile()
    size = Math.round(src.length/102.4)/10
    console.log(" Compiling: ".cyan+ "/main.js (#{size}Kb #{if minify then 'minified' else 'source'})".grey)
    res.charset = 'utf-8'
    res.header('Cache-Control', 'no-cache')
    res.contentType('text/javascript')
    res.send src

  server.get '/lovely.io/:module.js', (req, res) ->
    module = req.params.module
    script = "#{base}/#{module}/current/build/#{module}#{if minify then '' else '-src'}.js"

    console.log(" Serving:   ".magenta+ "'#{module}' module from #{script}".grey)

    fs.readFile script, (err, data)->
      res.contentType('text/javascript')
      res.send data

  server.get '/favicon.ico', (req, res) ->
    res.send '' # just keeping it happy

  # listening all the static content in the user project
  server.get /^\/(.*?)$/, (req, res) ->
    minify    = req.query.minify is 'true'
    filename  = req.params[0] || 'index'
    extension = filename.split('.')
    extension = extension[extension.length - 1]

    unless extension in ['css', 'html', 'js']
      filename += '.html'
      extension = 'html'

    switch extension
      when 'css' then content_type = 'text/css'
      when 'js'  then content_type = 'text/javascript'
      else            content_type = 'text/html'

    fs.readFile "#{process.cwd()}/#{filename}", (err, data)->
      console.log("") if extension is "html"
      console.log(" Sending:   "+ "/#{filename} (#{content_type})".grey)

      res.charset = 'utf-8'
      res.contentType(content_type)
      res.send data


  server.listen(port)

  print "Listening at: http://127.0.0.0:#{port}\n"+
    "Press Ctrl+C to hung up".grey


exports.help = (args) ->
  """
  Runs a development server in a LovelyIO module project

  Usage:
      lovely server [port]

  """