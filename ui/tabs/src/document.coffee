#
# Document level hooks
#
# Copyright (C) 2012 Nikolay Nemshilov
#
$ ->
  $('.lui-tabs').forEach (element)->
    unless element instanceof Tabs
      new Tabs(element._)