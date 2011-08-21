#
# Dnd main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core     = require('core')
$        = require('dom')

ext      = core.ext
bind     = core.bind
Hash     = core.Hash
isString = core.isString
isArray  = core.isArray
Element  = $.Element



# gluing in the files
include 'src/draggable'
include 'src/droppable'
include 'src/document'


# attaching the element level extensions
Element.include
  draggable: Draggable.draggable
  droppable: Droppable.droppable


# exporting the modules to the public
ext exports,
  version: '%{version}'
  Draggable: Draggable
  Droppable: Droppable