#
# The Ajax main unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Ajax
  extend:
    Options:
      method:   'post'
      encoding: 'utf8'

  constructor: (url, options) ->
