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
module.exports.__defineGetter__ 'Test', ->
  require('./test/core')


# Deffering access to the chai libs
module.exports.__defineGetter__ 'assert', ->
  require('chai').assert

module.exports.__defineGetter__ 'should', ->
  require('chai').should

module.exports.__defineGetter__ 'expect', ->
  require('chai').expect
