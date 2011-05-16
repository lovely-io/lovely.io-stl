#
# DOM-document specific wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Document = new Class Wrapper,
  # copying the standard events handling interface from `Element.prototype`
  include: Element_events

  #
  # Returns a wrapped reference to the window where
  # this document belongs to
  #
  # @return {Window} window refrence
  #
  window: ->
    wrap(@_.defaultView || @_.parentWindow)


# quick current document wrapper access
current_Document = new Document(document)