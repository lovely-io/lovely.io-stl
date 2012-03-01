#
# Zoom main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')

# local variables assignments
Class   = core.Class
Element = $.Element

# glue in your files
include 'src/zoom'

# export your objects in the module
exports.version = '%{version}'

# global exports (don't use unless you're really need that)
global.my_stuff = 'that pollutes the global scope'