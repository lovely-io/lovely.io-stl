#
# The forms handling module for Lovely IO
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Lovely ['dom'], ($) ->
  ext     = Lovely.ext
  Class   = Lovely.Class
  Element = $.Element

  include 'src/form'
  include 'src/input'

  # setting up the dynamic typecasting for the form-elements
  ext Element.Wrappers,
    FORM:     Form
    INPUT:    Input
    SELECT:   Input
    TEXTAREA: Input

  # exporting the globals and the module
  ext Form,
    version: '%{version}'
    Input:   Input