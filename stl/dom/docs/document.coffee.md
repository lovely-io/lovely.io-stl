DOM-document specific wrapper

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
class Document extends Wrapper
  # copying the standard events handling and navigation interfaces
  include: [Element_events]

  constructor: (document)->
    Wrapper.call(this, document)
```

Returns a wrapped reference to the window where
this document belongs to

@return {Window} window refrence

```coffee-aside
  window: ->
    wrap(@_.defaultView || @_.parentWindow)

  # copying the search interface from the Element unit
  find:  Element.prototype.find
  first: Element.prototype.first


# quick current document wrapper access
current_Document = new Document(document)
```
