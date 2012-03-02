#
# Zoom main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')
ui      = require('ui')

# local variables assignments
ext     = core.ext
Class   = core.Class
Element = $.Element
Locker  = ui.Locker

# glue in your files
include 'src/zoom'
include 'src/document'

# export your objects in the module
exports = ext(Zoom, {
  version: '%{version}'
});