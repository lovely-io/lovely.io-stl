#
# Ui-Core main file
#
# Copyright (C) 2012 Nikolay Nemshilov
#

# hook up dependencies
core     = require('core')
dom      = require('dom')

A        = core.A
ext      = core.ext
Class    = core.Class
Event    = dom.Event
Element  = dom.Element
Document = dom.Document
Window   = dom.Window
Input    = dom.Input

# glue in the files
include 'src/event'
include 'src/element'
include 'src/button'
include 'src/icon'

# export your objects in the module
ext exports,
  version: '%{version}'
  Button:  Button
  Icon:    Icon
