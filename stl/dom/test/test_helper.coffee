#
# Local test-helper
#
# Copyright (C) 2011 Nikoaly Nemshilov
#
Source   = require('../../../cli/source')

src =
  core: Source.compile(__dirname + "/../../core/")
  dom:  Source.compile(__dirname + "/../")

global.assert   = require('assert')

#
# A simple shortcut over the Vows to make
# a single batch descriptions
#
# @param {String} name
# @param {Object} current module
# @param {Object} batch hash
# @return void
#
global.describe = (thing, module, batch) ->
  require('vows').describe(thing).addBatch(batch).export(module)

# making a little local server with 'express' to load the fixtures into the zombie
server  = require('express').createServer()

server.get '/', (req, resp) ->
  resp.send('<html><body>Hello</body></html>')

server.get '/core.js', (req, resp) ->
  resp.send src.core

server.get '/dom.js', (req, resp) ->
  resp.send src.dom

server.get '/test.html', (req, resp) ->
  resp.send """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/dom.js"></script>
    </head>
  </html>
  """

global.server = server

#
# A shortcut to dynamically define the server responses
#
# @param {Object} routes and responses
# @return {undefined}
#
global.server_respond = (defs) ->
  for route, response of defs
    do (route, response) ->
      server.get route, (req, resp) ->
        resp.send(response)

# a global zombie-browser reference
global.Browser = require('zombie').Browser

#
# Our own shortcut for the browser load
# so that you didn't need to carry around
# the domain-name, port and things
#
# @param {String} relative url address
# @param {Object} browser options
# @param {Function} vows async callback
#
Browser.open = (url, options, callback) ->
  if !server.active
    server.listen(3000)
    server.active = true

  if !callback
    callback = options
    options  = {}

  browser = new Browser(options)

  browser.alerts = []
  browser.onalert (message) ->
    browser.alerts.push(message)

  browser.visit 'http://localhost:3000' + url, (err, browser) ->
    throw err if err
    browser.wait callback