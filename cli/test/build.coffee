#
# The test modules building tools
#
# Copyright (C) 2012-2013 Nikolay Nemshilov
#

fs      = require('fs')
path    = require('path')
server  = require('./server')
source  = require('../source')
packge  = require('../package')

cur_dir = process.cwd()
packg   = packge.read(cur_dir)
method  = if process.argv.indexOf('--minify') > -1 then 'minify' else 'compile'
build   = source[method](cur_dir)

server.set "/#{packg.name}.js", build
server.set "/#{packg.name}-auto-dummy.html", """
  <html>
    <head>
      <script src="/core.js"></script>
      <script type="text/javascript">
        Lovely(['#{packg.name}'], function() {});
      </script>
    </head>
    <body>
      Dummy page for: '#{packg.name}'
    </body>
  </html>
"""

exports.build = build

#
# Creates a callback for the mocha `before` calls
# that automatically binds the module, load's its
# page, extracts the module object and returns it
# in the callback function
#
exports.load = (options, callback)->
  if !callback
    callback = options
    options  = {}

  if typeof(options) is 'string'
    url     = options
    options = {}
  else
    url = "/#{packg.name}-auto-dummy.html"

  (done)->
    server.get url, options, (browser)->
      callback(browser.window.Lovely.module(packg.name), browser.window, browser)
      done()
