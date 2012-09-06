#
# NodeJS lovely API
#
source = require('./source')


#
# building the core package
#
# NOTE: we're exporting the `Lovely` object itself
#
eval(source.compile(__dirname + "/../stl/core/"))
module.exports = this.Lovely


#
# Defining the development tools initialization
# so that it didn't bother until the code actually
# called the `Lovely.Test` property
#
Test = null
module.exports.__defineGetter__ 'Test', ->
  Test or= require('./test/core')

#
# Deffering access to the patched asserts library
#
module.exports.__defineGetter__ 'assert', ->
  require('./test/assert')