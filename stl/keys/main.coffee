#
# Keys main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core     = require('core')
dom      = require('dom')

A        = core.A
Event    = dom.Event
Element  = dom.Element
Document = dom.Document
Window   = dom.Window

# glue in the files
include 'src/event'
include 'src/element'


exports.version = '%{version}'