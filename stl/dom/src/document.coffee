#
# DOM-document specific wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Document = new Class Wrapper,

  #
  # Returns a wrapped reference to the window where
  # this document belongs to
  #
  # @return {Window} window refrence
  #
  window: ->
    wrap(@_.defaultView || @_.parentWindow)