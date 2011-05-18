#
# The AJAX support module for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
core  = require('core')
ext   = core.ext
Class = core.Class

include 'src/ajax'
include 'src/jsonp'
include 'src/iframe'

exports = ext Ajax,
  version: '%{version}'