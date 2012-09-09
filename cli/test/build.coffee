#
# The test modules building tools
#

fs      = require('fs')
path    = require('path')
server  = require('./server')
source  = require('../source')
packge  = require('../package')

dirs    = {}
builds  = {}
binds   = {}
packs   = {}

#
# reads package.json definitions from a module reference
#
packg = (module)->
  packs[module.filename] or= packge.read(moddir(module))


#
# Resolves the module main working directory
#
moddir  = (module)->
  unless module.filename of dirs
    dirname = path.dirname(module.filename)

    while dirname != '/'
      if fs.existsSync("#{dirname}/package.json")
        dirs[module.filename] = dirname
        break

      dirname = path.join(dirname, '..')

  dirs[module.filename]


#
# Simply bilds the module source and returns it as a string
#
exports.build = build = (module)->
  builds[module.filename] or= source.compile(moddir(module))


#
# Bind the built module to the server along with a dummy page for it's test
#
exports.bind = bind = (module)->
  unless module.filename of binds
    pack = packg(module)
    src  = build(module)

    server.set "/#{pack.name}.js",   binds[module.filename] = src
    server.set "/#{pack.name}-auto-dummy.html", """
      <html>
        <head>
          <script src="/core.js"></script>
          <script type="text/javascript">
            Lovely(['#{pack.name}'], function() {});
          </script>
        </head>
        <body>
          Dummy page for: '#{pack.name}'
        </body>
      </html>
    """

  binds[module.filename]


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

  pack = packg(module)
  src  = bind(module)

  if typeof(options) is 'string'
    url = options
  else
    url = "/#{pack.name}-auto-dummy.html"

  (done)->
    server.get url, options, (browser)->
      callback(browser.window.Lovely.module(pack.name), browser.window, browser)
      done()
