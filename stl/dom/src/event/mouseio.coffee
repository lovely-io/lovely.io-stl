#
# 'mouseenter', 'mouseleave' events emulation
#
# Copyright (C) 2011
#
mouseio_index    = []
mouseio_inactive = true

#
# Fires the actual mouseenter/mouseleave event
#
# @param {HTMLEvent} original event
# @param {HTMLElement} raw dom element
# @param {Boolean} mouseenter or mouseleave
# @return void
#
mouseio_emit = (raw, element, enter) ->
  event         = new Event(raw)
  event.type    = if enter is true then 'mouseenter' else 'mouseleave'
  event.bubbles = false
  event.stopped = true
  event.target  = wrap(element)

  # replacing the #find method so that UJS didn't
  # get broke with trying to find nested elements
  event.find = (css_rule)->
    for element in current_Document.find(css_rule, true)
      if element is this.target._
        return this.target
    return null

  event.target.emit(event)
  current_Document.emit(event)


#
# Figures out the enter/leave events by listening the
# mouseovers in the document
#
# @param {HTMLEvent} raw dom event
# @return void
#
mouseio_handler = (e)->
  target  = e.target
  from    = e.relatedTarget
  element = target
  passed  = false
  parents = []
  id      = null
  event   = null

  while element.nodeType is 1
    id = uid(element)

    if mouseio_index[id] is undefined
      mouseio_emit e, element, mouseio_index[id] = true

    passed = true if element is from

    parents.push(element)

    element = element.parentNode


  if from and !passed
    while from isnt null && from.nodeType is 1 && parents.indexOf(from) is -1
      id = uid(from)
      if mouseio_index[id] isnt undefined
        mouseio_emit e, from, mouseio_index[id] = undefined

      from = from.parentNode

  return #nothing


#
# Calling 'mouseleave' for all currently active elements on the page
#
# @param {HTMLEvent} raw dom-event
# @return void
#
mouseio_reset = (e)->
  for element, id in mouseio_index
    if element && id of Wrapper_Cache
      mouseio_emit e, Wrapper_Cache[id]._, false

  return #nothing


#
# Activating the mouse-io events emulation
#
# @return void
#
mouseio_activate = ->
  if mouseio_inactive
    mouseio_inactive = false

    document.addEventListener('mouseover', mouseio_handler, false)
    window.addEventListener('blur', mouseio_reset, false)

  return #nothing