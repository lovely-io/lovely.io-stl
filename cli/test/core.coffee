#
# The standard lovely CLI testing utils
#
# Copyright (C) 2012
#

# patching up the 'should' to have the 'same' and 'sameAs' assertions
should   = require('should')

should.Assertion.prototype.same   =
should.Assertion.prototype.sameAs =
  should.Assertion.prototype.equal


# exporting the server API
server   = require('./server')

exports.set = server.set
exports.get = server.get


# source building tools
fs      = require('fs')
path    = require('path')
source  = require('../source')
packg   = require('../package')

moddir  = (module)->
  dirname = path.dirname(module.filename)

  while dirname != '/'
    return dirname if fs.existsSync("#{dirname}/package.json")
    dirname = path.join(dirname, '..')

exports.build = build = (module)->
  source.compile(moddir(module))

exports.bind = (module)->
  pack = packg.read(moddir(module))
  src  = build(module)

  server.set "/#{pack.name}.js", src
  server.set "/test-#{pack.name}.html", """
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