#
# NodeJS lovely API
#
source = require('./source')

# the packages building tools
sources_cache  = {}
exports.source = compile_source = (name)->
  sources_cache[name] or= source.compile(__dirname + "/../stl/#{name}/")


# building the core package
eval(core = compile_source('core'))

exports.Lovely = this.Lovely

for key of this.Lovely
  exports[key] = this.Lovely[key]

# Defining the development tools initialization
Test = null
exports.__defineGetter__ 'Test', ->
  Test or= require('./test/core')
