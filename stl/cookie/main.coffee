#
# cookie main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core     = require('core')
Class    = core.Class
Options  = core.Options
document = global.document

# glue in your files
include 'src/cookie'

# export your objects in the module
exports = Cookie
