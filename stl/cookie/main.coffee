#
# Cookie main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core     = require('core')
ext      = core.ext
Class    = core.Class
document = global.document

include 'src/cookie'

Cookie.version = '%{version}'

exports = Cookie
