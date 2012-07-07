This module provides correctly bubbling 'focus' and 'blur' events

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
```

Bypasses the 'focus'/'blur' events to the parent element when needed

@param {HTMLEvent} raw dom-event

```coffee-aside
focusio_boobler = (raw_event)->
  event = new Event(raw_event)

  if event.target instanceof Element
    event.target.parent().emit(event)

  return #nothing
```

Hooking up the 'focus' and 'blur' events
at the document level and then rebooble them
manually like they were normal events

```coffee-aside
document.addEventListener('focus', focusio_boobler, true)
document.addEventListener('blur',  focusio_boobler, true)
```
