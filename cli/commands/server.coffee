#
# The package local server. It builds a user's
# package on fly alowing to effectively split it
# apart and work with it in a nice environment
#
# Copyright (C) 2011 Nikolay Nemshilov
#
exports.init = (args) ->
  fs      = require('fs')
  path    = require('path')
  source  = require('../source')
  package = require('../package')
  express = require('express')
  server  = express.createServer()
  port    = args[0] || lovelyrc.port || 3000
  base    = lovelyrc.base
  minify  = false

  base[base.length - 1] isnt '/' and base += '/'
  base += "packages"

  #
  # serving the modules
  # NOTE: if the module name is the same as the current package name
  #       then the module will be dynamically compiled out of the source
  #
  server.get '/:module.js', (req, res) ->
    module = req.params.module

    if module == package.name || module == 'main'
      src  = if minify then source.minify() else source.compile()
      size = Math.round(src.length/102.4)/10
      console.log(" Compiling: ".cyan+ "/#{module}.js (#{size}Kb #{if minify then 'minified' else 'source'})".grey)

    else
      src = "/#{module}/current/build/#{module}#{if minify then '' else '-src'}.js"
      console.log(" Serving:   ".magenta + "/#{module}.js -> ~/.lovely/packages#{src}".grey)
      src = fs.readFileSync("#{base}/#{src}").toString()


    res.charset = 'utf-8'
    res.header('Cache-Control', 'no-cache')
    res.contentType('text/javascript')
    res.send src

  # just a dummy favicon response
  server.get '/favicon.ico', (req, res) ->
    res.send ''

  # listening all the static content in the user project
  server.get /^\/(.*?)$/, (req, res) ->
    minify    = req.query.minify is 'true'
    shared    = "#{__dirname}/../server"

    file_in = (directory)->
      for ext in ['', '.html', 'index.html', '/index.html']
        relname  = "#{req.params[0]}#{ext}"
        fullname = "#{directory}/#{relname}"
        if path.existsSync(fullname) and !fs.statSync(fullname).isDirectory()
          return relname

      return false

    content_type = (name)->
      extension = (name || '').split('.')
      switch extension[extension.length - 1]
        when 'css' then return 'text/css'
        when 'js'  then return 'text/javascript'
        else            return 'text/html'


    if filename = file_in(process.cwd())
      console.log("") if filename.substr(filename.length-4) is 'html'
      console.log(" Sending:   "+ "/#{filename} (#{content_type(filename)})".grey)
      data = fs.readFileSync("#{process.cwd()}/#{filename}")

    else if filename = file_in(shared)
      console.log(" Sending:   "+ "/#{filename} -> ~/.lovely/server/#{filename}".grey)
      data = fs.readFileSync("#{shared}/#{filename}")

    else
      console.log("\n Sending:   "+ "404 Error".red + " /#{req.params[0]} is not found".grey)
      data = fs.readFileSync("#{shared}/404.html")

    res.charset = 'utf-8'
    res.contentType(content_type(filename))
    res.send data


  server.listen(port)

  print "Listening: http://127.0.0.0:#{port}\n"+
    "Press Ctrl+C to hung up".grey


exports.help = (args) ->
  """
  Runs a development server in a LovelyIO module project

  Usage:
      lovely server [port]

  """