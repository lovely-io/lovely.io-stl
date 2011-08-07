#
# The AJAX support module for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
$        = require('dom')
core     = require('core')

ext      = core.ext
bind     = core.bind
Hash     = core.Hash
Class    = core.Class
isArray  = core.isArray
isObject = core.isObject
doc      = $(global.document)
Form     = $.Form
Element  = $.Element
JSON     = global.JSON


include 'src/ajax'
include 'src/jsonp'
include 'src/hash'
include 'src/form'
include 'src/element'

exports = ext Ajax,
  version: '%{version}'