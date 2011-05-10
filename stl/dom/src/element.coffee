#
# Defines the basic dom-element wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element = new Class Wrapper,

  initialize: (element, options) ->
    if typeof(element) is 'string'
      element = document.createElement(element)
      `options == null` && options = {}

      for key of options
        element[key] = options[key]

    this.$super(element)