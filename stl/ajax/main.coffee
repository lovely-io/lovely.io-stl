#
# The AJAX support module for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Lovely ->
  ext   = Lovely.ext
  Class = Lovely.Class

  include 'src/ajax'
  include 'src/jsonp'
  include 'src/iframe'

  ext Ajax,
    version: '%{version}'