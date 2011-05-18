#
# The forms handling module for Lovely IO
#
# Copyright (C) 2011 Nikolay Nemshilov
#
core    = require('core')
dom     = require('dom')

ext     = core.ext
Class   = core.Class
Element = dom.Element

include 'src/form'
include 'src/input'

# setting up the dynamic typecasting for the form-elements
ext Element.Wrappers,
  FORM:     Form
  INPUT:    Input
  SELECT:   Input
  TEXTAREA: Input

# exporting the globals and the module
exports = ext Form,
  version: '%{version}'
  Input:   Input