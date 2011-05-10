#
# The Ajax main unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Ajax = new Class
  extend:
    Options:
      method:   'post'
      encoding: 'utf8'

  initialize: (url, options) ->
