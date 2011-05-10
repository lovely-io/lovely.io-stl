#
# Node.js envinronment initializer for Lovely IO
#
# Copyright (C) 2011 Nikolay Nemshilov
#
fs  = require('fs')
sys = require('sys')
src = require('../../../cli/source')

# packing and initializing Lovely core
eval(src = src.compile(__dirname + "/../"))

# globalizing those ones so we didn't need to reinit them all the time
global.Lovely  = this.Lovely
global.util    = require('util')
global.vows    = require('vows')
global.assert  = require('assert')

assert.same    = assert.strictEqual
assert.notSame = assert.notStrictEqual

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
  vows.describe(thing).addBatch(batch).export(module)

# making a little local server with 'express' to load the fixtures into the zombie
server  = require('express').createServer()

server.get '/', (req, resp) ->
  resp.send('<html><body>Hello</body></html>')

server.get '/core.js', (req, resp) ->
  resp.send(src)

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
# @param {Function} vows async callback
#
Browser.open = (url, callback) ->
  if !server.active
    server.listen(3000)
    server.active = true

  browser = new Browser()

  browser.alerts = []
  browser.onalert (message) ->
    browser.alerts.push(message)

  browser.visit 'http://localhost:3000' + url, (err, browser) ->
    throw err if err
    browser.wait(callback)