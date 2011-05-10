#
# The JavaScript core extensions module for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Lovely ->
  ext = Lovely.ext

  include 'src/array'
  include 'src/string'
  include 'src/number'
  include 'src/function'

  {version: '%{version}'}