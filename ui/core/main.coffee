#
# Ui-Core main file
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
include 'src/ui_core'

# export your objects in the module
exports.version = '%{version}'
