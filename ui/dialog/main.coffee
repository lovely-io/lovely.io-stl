#
# Dialog main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')
UI      = require('ui')
Ajax    = require('ajax')

# local variables assignments
ext     = core.ext
Class   = core.Class
Element = $.Element
Input   = $.Input
Modal   = UI.Modal

# glue in your files
include 'src/dialog'
include 'src/info'
include 'src/alert'
include 'src/prompt'
include 'src/confirm'
include 'src/document'

# export your objects in the module
exports = ext Dialog,
  version: '%{version}'