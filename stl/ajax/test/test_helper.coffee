#
# The 'ajax' module test helper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Source   = require('../../../cli/source')

src =
  core: Source.compile(__dirname + "/../../core/")
  dom:  Source.compile(__dirname + "/../../dom/")
  ajax: Source.compile(__dirname + "/../")

exports.assert = assert = require('assert')

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
exports.describe = (thing, module, batch) ->
  require('vows').describe(thing).addBatch(batch).export(module)

# making a little local server with 'express' to load the fixtures into the zombie
global.server or= require('express').createServer()
exports.server = server

server.get '/core.js', (req, resp) ->
  resp.send src.core

server.get '/dom-0.0.0.js', (req, resp) ->
  resp.send src.dom

server.get '/ajax.js', (req, resp) ->
  resp.send src.ajax

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
# A helper method to load stuff into
# the browser and then access it from a test
#
# @param {String} url address
# @param {Vows} test erference
# @param {Function} optional callback
# @return void
#
exports.load = load = (url, test, callback)->
  Browser.open url, (err, browser) ->
    test.browser  = browser
    test.window   = browser.window
    test.document = browser.document
    test.Lovely   = browser.window.Lovely
    test.dom      = test.Lovely.module('dom')
    test.Ajax     = test.Lovely.module('ajax')
    test.Hash     = test.Lovely.Hash

    test.callback(err, if callback then callback.call(test, test.Ajax) else test.Ajax)


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
    browser.wait callback