#
# Local test-helper
#
# Copyright (C) 2011-2012 Nikoaly Nemshilov
#
Source   = require('../../../cli/source')

src =
  core: Source.compile(__dirname + "/../../core/")
  dom:  Source.compile(__dirname + "/../")

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

#
# Another shortcut. Loads up the url, finds
# and element with the specified 'id' and wraps
# it into the dom.Element object
#
# @param {String} url address
# @param {Vows} test reference
# @param {String} element's ID
# @return void
#
exports.load_element = (url, test, id) ->
  load url, test, (dom)->
    new dom.Element(this.document.getElementById(id))

# a global zombie-browser reference
exports.Browser = Browser = require('zombie').Browser

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
    browser.wait ->
      callback(browser.window.Lovely.module('dom'), browser.window, browser)

