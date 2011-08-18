#
# Date main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core      = require('core')
L         = core.L
ext       = core.ext
trim      = core.trim
zerofy    = (value)->
  (if value < 10 then '0' else '') + value
re_escape = (string)->
  string.replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1')

# glueing in the files
include 'src/i18n'
include 'src/parse'
include 'src/format'

exports.version = '%{version}'