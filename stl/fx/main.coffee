#
# The main Fx file
#
# Copyright (C) 2011 Nikolay Nemshilov
#
core       = require('core')
$          = require('dom')

ext        = core.ext
bind       = core.bind
Class      = core.Class
List       = core.List
Element    = $.Element
Browser    = $.Browser
HTML       = global.document.documentElement
IE_OPACITY = 'filter' of HTML.style and !('opacity' of HTML.style)

include 'src/fx'
include 'src/fx/attr'
include 'src/fx/scroll'
include 'src/fx/style'
include 'src/element'
include 'src/colors'

exports = ext Fx,
  version: "%{version}"