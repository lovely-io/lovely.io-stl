#
# The document level hooks for the draggable units
#
# Copyright (C) 2011 Nikolay Nemshilov
#

$(document).on
  mousemove: (event)->
    if Draggable.current isnt null
      draggable_move(event, Draggable.current)
      droppable_hover(event, Draggable.current)
    return # nothing

  mouseup: (event)->
    if Draggable.current isnt null
      draggable_drop(event, Draggable.current)
    return # nothing

  mousedown: (event)->
    if Draggable.current is null
      element = event.target

      while element instanceof $.Element
        if element.attr('data-draggable') isnt null
          element.draggable()

        if '__draggable' of element
          event.stop()
          draggable_start(event, element)
          break

        element = element.parent()

    return # nothing

$(window).on 'blur', (event)->
  if Draggable.current isnt null
    draggable_drop(event, Draggable.current)
  return # nothing