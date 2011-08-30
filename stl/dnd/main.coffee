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
isObject = core.isObject
Element  = $.Element

# merges the draggable/droppable options in one hash
merge = (name, element, local)->
  options = ext({}, exports[name[0].toUpperCase() + name.substr(1)].Options)
  options = ext(options, new Function("return #{element.attr('data-'+name)}")())
  options = ext(options, local)
  events  = ['beforedrag', 'dragstart', 'drag', 'dragend', 'dragenter', 'dragleave', 'drop']

  for name in events
    if name of options
      element.on(name, options[name])
      delete(options[name])

  return options


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