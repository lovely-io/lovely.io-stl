#
# The package local server. It builds a user's
# package on fly alowing to effectively split it
# apart and work with it in a nice environment
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
exports.init = (args) ->
  fs       = require('fs')
  source   = require('../source')
  pack     = require('../package')
  express  = require('express')
  lovelyrc = require('../lovelyrc')
  server   = express(express.bodyParser())
  port     = args[0] || lovelyrc.port || 3000
  base     = lovelyrc.base + "/packages"
  minify   = false

  #
  # serving the modules
  # NOTE: if the module name is the same as the current package name
  #       then the module will be dynamically compiled out of the source
  #
  server.all '/:module.js', (req, res) ->
    module = req.params.module
    host   = "http://#{req.host}:#{port}"

    if module == pack.name || module == 'main'
      src  = if minify then source.minify() else source.compile()
      size = Math.round(src.length/102.4)/10
      console.log(" Compiling: ".cyan+ "/#{module}.js (#{size}Kb #{if minify then 'minified' else 'source'})".grey)

    else if fs.existsSync("#{process.cwd()}/#{module}.js")
      src = fs.readFileSync("#{process.cwd()}/#{module}.js")
      console.log(" Sending:   "+ "/#{module}.js (text/javascript)".grey)

    else

      if match = module.match(/^(.+?)\-(\d+\.\d+\.\d+.*?)$/)
        module  = match[1]
        version = match[2]
      else
        version = 'active'

      src = "/#{module}/#{version}/build.js"
      console.log(" Serving:   ".magenta + "/#{module}.js -> ~/.lovely/packages#{src}".grey)
      src = fs.readFileSync("#{base}/#{src}").toString()

      # adding the local domain-name/port to the CSS sources
      for match in (src.match(/url\(('|")[^'"]+?\/images\/[^'"]+?\1\)/g) || [])
        src = src.replace(match, match.replace(/^url\(('|")/, "url($1#{host}"))

    res.charset = 'utf-8'
    res.header('Cache-Control', 'no-cache')
    res.header('Content-Type', 'text/javascript')
    res.send src

  # just a dummy favicon response
  server.get '/favicon.ico', (req, res) ->
    res.send ''

  # listening all the static content in the user project
  server.all /^\/(.*?)$/, (req, res) ->
    minify = req.query.minify is 'true'
    shared = "#{lovelyrc.base}/server"

    file_in = (directory)->
      for ext in ['', '.html', 'index.html', '/index.html']
        relname  = "#{req.params[0]}#{ext}"
        fullname = "#{directory}/#{relname}"
        if fs.existsSync(fullname) and !fs.statSync(fullname).isDirectory()
          return relname

      return false

    content_type = (name)->
      extension = (name || '').split('.')
      switch extension[extension.length - 1]
        when 'css'    then return 'text/css'
        when 'sass'   then return 'text/css'
        when 'scss'   then return 'text/css'
        when 'styl'   then return 'text/css'
        when 'js'     then return 'text/javascript'
        when 'coffee' then return 'text/javascript'
        when 'ico'    then return 'image/icon'
        when 'png'    then return 'image/png'
        when 'jpg'    then return 'image/jpg'
        when 'gif'    then return 'image/gif'
        when 'swf'    then return 'application/x-shockwave-flash'
        when 'eot'    then return "application/vnd.ms-fontobject"
        when 'ttf'    then return "application/x-font-ttf"
        when 'woff'   then return "application/x-font-woff"
        when 'json'   then return "application/json"
        else               return 'text/html'

    if req.method is 'POST'
      console.log("\n POST:     ", JSON.stringify(req.body).grey)

    if filename = file_in(process.cwd())
      console.log("") if filename.substr(filename.length-4) is 'html'
      console.log(" Sending:   "+ "/#{filename} (#{content_type(filename)})".grey)
      filepath = "#{process.cwd()}/#{filename}"

    else if filename = file_in("#{lovelyrc.base}/packages")
      console.log(" Sending:   "+ "/#{filename} -> ~/.lovely/packages/#{filename}".grey)
      filepath = "#{lovelyrc.base}/packages/#{filename}"

    else if filename = file_in(shared)
      console.log("") if filename.substr(filename.length-4) is 'html'
      console.log(" Sending:   "+ "/#{filename} -> ~/.lovely/server/#{filename}".grey)
      filepath = "#{shared}/#{filename}"

    else
      console.log("\n Sending:   "+ "404 Error".red + " /#{req.params[0]} is not found".grey)
      filepath = "#{shared}/404.html"

    content = fs.readFileSync(filepath)
    if /\.coffee$/.test(filename)
      content = source.assemble(content.toString(), 'coffee')
    if /\.sass$/.test(filename)
      content = source.style(content.toString(), 'sass')
    if /\.styl$/.test(filename)
      content = source.style(content.toString(), 'styl')
    if /\.scss$/.test(filename)
      content = source.style(content.toString(), 'scss')

    res.charset = 'utf-8'
    res.header('Content-Type', content_type(filename))
    res.send content


  server.listen(port)

  print "Listening: http://127.0.0.1:#{port}\n"+
    "Press Ctrl+C to hung up".grey


exports.help = (args) ->
  """
  Runs a development server in a LovelyIO module project

  Usage:
      lovely server [port]

  """