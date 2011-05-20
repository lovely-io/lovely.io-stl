#
# DOM-document specific wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Document extends Wrapper
  # copying the standard events handling and navigation interfaces
  include: [Element_events, Search_module]

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