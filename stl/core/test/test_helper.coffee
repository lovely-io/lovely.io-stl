#
# Node.js envinronment initializer for Lovely IO
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
fs  = require('fs')
sys = require('util')

src = require('../../../cli/source')

# packing and initializing Lovely core
eval(src = src.compile(__dirname + "/../"))

# globalizing those ones so we didn't need to reinit them all the time
exports.Lovely  = this.Lovely
exports.util    = require('util')
exports.should  = should = require('should')

should.Assertion.prototype.same   =
should.Assertion.prototype.sameAs =
  should.Assertion.prototype.equal

# making a little local server with 'express' to load the fixtures into the zombie
global.server or= require('express')()
exports.server = server

server.get '/', (req, resp) ->
  resp.send('<html><body>Hello</body></html>')

server.get '/core.js', (req, resp) ->
  resp.send(src)

exports.server = server

#
# A shortcut to dynamically define the server responses
#
# @param {Object} routes and responses
# @return {undefined}
#
server.respond = (defs) ->
  for route, response of defs
    do (route, response) ->
      server.get route, (req, resp) ->
        resp.send(response)

# a global zombie-browser reference
exports.Browser = Browser = require('zombie').Browser

# a shortcut to define server responses via the Browser API
Browser.respond = (defs)->
  server.respond(defs)

#
# Our own shortcut for the browser load
# so that you didn't need to carry around
# the domain-name, port and things
#
# @param {String} relative url address
# @param {Function} vows callback
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
    browser.wait -> callback(browser)
