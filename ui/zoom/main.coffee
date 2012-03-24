#
# Zoom main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
UI      = require('ui')
$       = Lovely.module('dom') # reusing UI's dom module


# local variables assignments
ext     = core.ext
Class   = core.Class
Options = core.Options
Element = $.Element
Locker  = UI.Locker
Modal   = UI.Modal

# glue in your files
include 'src/zoom'
include 'src/document'

# export your objects in the module
exports = ext(Zoom, {
  version: '%{version}'
});