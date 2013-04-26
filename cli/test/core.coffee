#
# The standard lovely CLI testing utils
#
# Copyright (C) 2012
#

# exporting the server API
server   = require('./server')

exports.set = server.set
exports.get = server.get


# source building tools
build   = require('./build')

exports.build = build.build
exports.bind  = build.bind
exports.load  = build.load
