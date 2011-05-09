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
  minify  = false

  # dynamically serving the main module script
  server.get '/main.js', (req, res) ->
    res.send if minify then source.minify() else source.compile()

  server.get '/lovely/:module.js', (req, res) ->
    # TODO make the modules hookable form here
    res.send req.params.module

  server.get '/favicon.ico', (req, res) ->
    res.send '' # just keeping it happy

  # listening all the pages in the user project
  server.get '/:page?', (req, res) ->
    minify = req.query.minify is 'true'
    res.send fs.readFileSync(
      "#{process.cwd()}/#{req.params.page || 'index'}.html"
    )

  server.listen(port)

  print """
  Listening at: http://127.0.0.0:#{port}
  Press Ctrl+C to hung up
  """


exports.help = (args) ->
  """
  Runs a development server in a LovelyIO module project

  Usage:
      lovely server [port]

  """