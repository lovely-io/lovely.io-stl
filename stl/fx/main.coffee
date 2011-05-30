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
Hash       = core.Hash
isObject   = core.isObject
Element    = $.Element
Browser    = $.Browser
HTML       = global.document.documentElement
IE_OPACITY = 'filter' of HTML.style and !('opacity' of HTML.style)

include 'src/fx'
include 'src/fx/attr'
include 'src/fx/scroll'
include 'src/fx/style'
include 'src/fx/highlight'
include 'src/fx/twin'
include 'src/fx/fade'
include 'src/element'
include 'src/colors'

exports = ext Fx,
  version: "%{version}"