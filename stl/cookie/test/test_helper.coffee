#
# The unit-tests hooks for the pacakge
#
# Copyright (C) 2011 Nikolay Nemshilov
#

fs  = require('fs')
sys = require('sys')
src = require('../../../cli/source')

# packing and initializing Lovely core
eval(src.compile(__dirname + "/../../core/"))

global.Lovely = this.Lovely

# packing and initializing the 'lang' package
eval(src.compile(__dirname + "/../"))

# globalizing those ones so we didn't need to reinit them all the time
exports.Lovely  = this.Lovely
exports.util    = require('util')
exports.assert  = assert = require('assert')

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
exports.describe = (thing, module, batch) ->
  require('vows').describe(thing).addBatch(batch).export(module)
