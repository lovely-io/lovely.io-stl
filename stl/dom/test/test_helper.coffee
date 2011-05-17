#
# Local test-helper
#
# Copyright (C) 2011 Nikoaly Nemshilov
#
Source   = require('../../../cli/source')

src =
  core: Source.compile(__dirname + "/../../core/")
  dom:  Source.compile(__dirname + "/../")

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
global.server.respond = (defs) ->
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
global.load = (url, test, callback)->
  Browser.open url, (err, browser) ->
    test.browser  = browser
    test.window   = browser.window
    test.document = browser.document
    test.Lovely   = browser.window.Lovely
    test.dom      = test.Lovely.modules.dom
    test.Wrapper  = test.dom.Wrapper
    test.Element  = test.dom.Element
    test.Document = test.dom.Document
    test.Window   = test.dom.Window
    test.Event    = test.dom.Event
    test.Search   = test.dom.Search

    test.callback(err, if callback then callback.call(test, test.dom) else test.dom)

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
global.load_element = (url, test, id) ->
  load url, test, (dom)->
    new dom.Element(this.document.getElementById(id))

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