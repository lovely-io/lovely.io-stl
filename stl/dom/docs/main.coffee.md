The DOM management module for Lovely IO

Copyright (C) 2011-2013 Nikolay Nemshilov

```coffee-aside

include 'src/utils'
include 'src/browser'
include 'src/node_list'
include 'src/wrapper'
include 'src/element'
include 'src/element/events'
include 'src/element/styles'
include 'src/element/commons'
include 'src/element/dimensions'
include 'src/element/navigation'
include 'src/element/manipulation'
include 'src/document'
include 'src/window'
include 'src/style'
include 'src/form'
include 'src/input'
include 'src/event'
include 'src/event/delegation'
include 'src/event/mouseio'
include 'src/event/focusio'
include 'src/event/ready'
include 'src/casting'
include 'src/dollar'


# registering `Form` and `Input` for dynamic typecasting
Wrapper
  .set("form",     Form)
  .set("input",    Input)
  .set("button",   Input)
  .set("select",   Input)
  .set("textarea", Input)
  .set("optgroup", Input)
  .set("style",    Style)


# exporting the main units
exports = ext $,
  version:  '%{version}'
  Browser:  Browser
  Wrapper:  Wrapper
  Document: Document
  Element:  Element
  Window:   Window
  Event:    Event
  Form:     Form
  Input:    Input
  Style:    Style
  NodeList: NodeList
  eval:     global_eval
  uid:      uid
```
