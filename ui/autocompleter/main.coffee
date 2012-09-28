#
# Autocompleter main file
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
isArray = core.isArray

# glue in your files
include 'src/autocompleter'
include 'src/document'

# export your objects in the module
exports = ext Autocompleter,
  version: '%{version}'