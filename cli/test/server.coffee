#
# The test server code lives here
#
# Copyright (C) 2012 Nikolay Nemshilov
#

fs       = require('fs')
should   = require('should')
zombie   = require('zombie')
server   = require('express')()
lovelyrc = require('../lovelyrc')
cache    = {}

# making the development server
base     = lovelyrc.base + "/packages"

server.get '/', (req, resp) ->
  resp.send("<html><body>What a lovely day, isn't it?</body></html>")


server.get '/:name.js', (req, res)->
  name = req.params.name

  if match = name.match(/^(.+?)\-(\d+\.\d+\.\d+.*?)$/)
    name    = match[1]
    version = match[2]
  else
    version = 'active'

  filename = "#{base}/#{name}/#{version}/build.js"

  if "/#{name}.js" of cache
    src = cache["/#{name}.js"]
  else if fs.existsSync(filename)
    src = fs.readFileSync(filename).toString()
  else
    src = "404: can't find '#{name}'"

  # adding the local domain-name/port to the CSS sources
  for match in (src.match(/url\(('|")[^'"]+?\/images\/[^'"]+?\1\)/g) || [])
    src = src.replace(match, match.replace(/^url\(('|")/, "url($1#{host}"))

  res.charset = 'utf-8'
  res.header('Cache-Control', 'no-cache')
  res.header('Content-Type',  'text/javascript')
  res.send src


#
# A shortcut to dynamically define the server responses
#
# @param {Object} routes and responses
# @return {undefined}
#
exports.set = (defs, resp) ->
  if typeof(defs) is 'string'
    t = {}; t[defs] = resp; defs = t

  for route, response of defs
    do (route, response) ->
      cache[route] = response
      server.get route, (req, res)->
        res.send response



#
# Our own shortcut for the browser load
# so that you didn't need to carry around
# the domain-name, port and things
#
# @param {String} relative url address
# @param {Object} browser options
# @param {Function} vows async callback
#
exports.get = (url, options, callback) ->
  if !server.active
    server.listen(6789)
    server.active = true

  if !callback
    callback = options
    options  = {}

  browser = new zombie.Browser(options)

  browser.alerts = []
  browser.onalert (message) ->
    browser.alerts.push(message)

  browser.visit 'http://localhost:6789' + url, (err, browser) ->
    throw err if err
    browser.wait ->

      # patching the in-browser Object.prototype, so that the should.js worked in there
      Object.defineProperty browser.window.getGlobal().Object.prototype, 'should',
        set: ->
        get: -> new should.Assertion(Object(@).valueOf())
        configurable: true

      callback(browser)
