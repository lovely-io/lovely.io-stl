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
isString = core.isString
isArray  = core.isArray
Element  = $.Element

# merges a bunch of hashes (options)
merge   = ->
  result = {}
  for hash in arguments
    if isString(hash)
      hash = new Function("return #{hash}")();
    result = ext(result, hash) if hash

  result


# gluing in the files
include 'src/draggable'
include 'src/droppable'

# the global hooks
$(document).on 'move', (event)->
  if Draggable.current isnt null
    draggable_move event, Draggable.current

$(document).on 'mouseup', (event)->
  if Draggable.current isnt null
    draggable_drop event, Draggable.current

# checking for the auto-initializable units
$ ->
  $('[data-draggable]').forEach('draggable')
  $('[data-droppable]').forEach('droppable')


# attaching the element level extensions
Element.include
  draggable: Draggable.draggable
  droppable: Droppable.droppable


# exporting the modules to the public
ext exports,
  version: '%{version}'
  Draggable: Draggable
  Droppable: Droppable