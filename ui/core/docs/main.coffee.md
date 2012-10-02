Ui-Core main file

Copyright (C) 2012 Nikolay Nemshilov

```coffee-aside

# hook up dependencies
core     = require('core')
dom      = require('dom')
fx       = require('fx')

$        = dom
A        = core.A
ext      = core.ext
Hash     = core.Hash
isObject = core.isObject
Class    = core.Class
Event    = dom.Event
Element  = dom.Element
Document = dom.Document
Window   = dom.Window
Input    = dom.Input

# glue in the files
include 'src/util'
include 'src/options'
include 'src/event'
include 'src/element'
include 'src/button'
include 'src/icon'
include 'src/spinner'
include 'src/locker'
include 'src/modal'
include 'src/menu'

# export your objects in the module
ext exports,
  version: '%{version}'
  Options: Options
  Button:  Button
  Icon:    Icon
  Spinner: Spinner
  Locker:  Locker
  Modal:   Modal
  Menu:    Menu
```
