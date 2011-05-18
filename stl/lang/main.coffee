#
# The JavaScript core extensions module for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
core = require('core')
ext  = core.ext

include 'src/array'
include 'src/string'
include 'src/number'
include 'src/function'

exports.version = '%{version}'