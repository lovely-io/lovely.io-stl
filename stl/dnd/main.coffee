#
# Dnd main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')

ext     = core.ext
Element = $.Element

# gluing in the files
include 'src/draggable'
include 'src/droppable'


# attaching the element level extensions
Element.include
  draggable: Draggable.draggable
  droppable: Droppable.droppable


# exporting the modules to the public
ext exports,
  version: '%{version}'
  Draggable: Draggable
  Droppable: Droppable