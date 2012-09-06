#
# The test modules building tools
#

fs      = require('fs')
path    = require('path')
server  = require('./server')
source  = require('../source')
packg   = require('../package')

#
# Resolves the module main working directory
#
moddir  = (module)->
  dirname = path.dirname(module.filename)

  while dirname != '/'
    return dirname if fs.existsSync("#{dirname}/package.json")
    dirname = path.join(dirname, '..')

#
# Simply bilds the module source and returns it as a string
#
exports.build = build = (module)->
  source.compile(moddir(module))


exports.bind = bind = (module)->
  pack = packg.read(moddir(module))
  src  = build(module)

  server.set "/#{pack.name}.js",   src
  server.set "/#{pack.name}.html", """
    <html>
      <head>
        <script src="/core.js"></script>
        <script type="text/javascript">
          Lovely(['#{pack.name}'], function() {});
        </script>
      </head>
    </html>
  """

  return src

#
# Creates a callback for the mocha `before` calls
# that automatically binds the module, load's its
# page, extracts the module object and returns it
# in the callback function
#
exports.load = (module, options, callback)->
  if !callback
    callback = options
    options  = {}

  pack = packg.read(moddir(module))
  bind(module)

  if typeof(options) is 'string'
    url = options
  else
    url = "/#{pack.name}.html"

  (done)->
    server.get url, options, (browser)->
      callback(browser.window.Lovely.module(pack.name), browser.window, browser)
      done()
