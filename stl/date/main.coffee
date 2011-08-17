#
# Date main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
ext     = core.ext

# glueing in the files
include 'src/i18n'
include 'src/parse'
include 'src/format'

exports.version = '%{version}'