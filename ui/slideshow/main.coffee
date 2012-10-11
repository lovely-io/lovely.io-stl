#
# Slideshow main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')
UI      = require('ui')

# local variables assignments
ext     = core.ext
Class   = core.Class
Element = $.Element
Icon    = UI.Icon

# glue in your files
include 'src/slideshow'
include 'src/controls'

# export your objects in the module
exports = ext Slideshow,
  version:  '%{version}'
  Controls: Controls


# instantiating all the lists on ready
$ ->
  $('.lui-slideshow').forEach('cast', Slideshow)
