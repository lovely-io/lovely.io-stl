#
# This module provides correctly bubbling 'focus' and 'blur' events
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Bypasses the 'focus'/'blur' events to the parent element when needed
#
# @param {HTMLEvent} raw dom-event
#
focusio_boobler = (raw_event)->
  event      = new Event(raw_event)
  event.type = 'blur'
  event.type = 'focus' if raw_event.type is 'focusin' or raw_event.type is 'focus'

  if event.target instanceof Element
    event.target.parent().emit(event)

  return #nothing

#
# Hooking up the 'focus' and 'blur' events
# at the document level and then rebooble them
# manually like they were normal events
#
#
if BROWSER_OLD_IE
  document.attachEvent('onfocusin',  focus_boobler)
  document.attachEvent('onfocusout', focus_boobler)
else
  document.addEventListener('focus', focus_boobler, true)
  document.addEventListener('blur',  focus_boobler, true)