#
# The forms specific dom-wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Form = new Class Element,

  initialize: (options) ->
    this.$super 'form', options

  send: (options) ->