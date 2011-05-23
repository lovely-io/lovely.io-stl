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

    if module == package.name
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
    filename  = req.params[0] || 'index'
    extension = filename.split('.')
    extension = extension[extension.length - 1]
    shared    = "#{__dirname}/../server"

    unless extension in ['css', 'html', 'js']
      filename += '.html'
      extension = 'html'

    switch extension
      when 'css' then content_type = 'text/css'
      when 'js'  then content_type = 'text/javascript'
      else            content_type = 'text/html'

    if path.existsSync("#{process.cwd()}/#{filename}")
      console.log("") if extension is "html"
      console.log(" Sending:   "+ "/#{filename} (#{content_type})".grey)
      data = fs.readFileSync("#{process.cwd()}/#{filename}")

    else if path.existsSync("#{shared}/#{filename}")
      console.log(" Sending:   "+ "/#{filename} (text/css) from shared directory".grey)
      data = fs.readFileSync("#{shared}/#{filename}")

    else
      console.log("\n Sending: "+ "404 Error".red + " /#{filename} is not found".grey)
      data = """
      <html>
        <body>
          <h1>404 Error</h1>
          <p>The page is not found</p>
        </body>
      </html>
      """

    res.charset = 'utf-8'
    res.contentType(content_type)
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