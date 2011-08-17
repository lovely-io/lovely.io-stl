#
# Date main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
ext     = core.ext
zerofy  = (value)->
  (if value < 10 then '0' else '') + value

# glueing in the files
include 'src/i18n'
include 'src/parse'
include 'src/format'

exports.version = '%{version}'