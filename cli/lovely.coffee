#
# NodeJS lovely API
#
source = require('./source')

# the packages building tools
sources_cache  = {}
compile_source = (name)->
  sources_cache[name] or= source.compile(__dirname + "/../stl/#{name}/")

#
# building the core package
#
# NOTE: we're exporting the `Lovely` object itself
#
eval(core = compile_source('core'))
module.exports = this.Lovely


#
# Defining the development tools initialization
# so that it didn't bother until the code actually
# called the `Lovely.Test` property
#
Test = null
module.exports.__defineGetter__ 'Test', ->
  Test or= require('./test/core')
