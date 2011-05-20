#
# The forms specific dom-wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Form extends Element

  constructor: (options) ->
    this.$super 'form', options

  send: (options) ->