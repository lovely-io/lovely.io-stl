#
# The DOM management module for Lovely IO
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Lovely [], ->
  ext      = Lovely.ext
  Class    = Lovely.Class
  window   = this
  document = this.document
  HTML     = document.documentElement

  include 'src/browser'
  include 'src/wrapper'
  include 'src/document'
  include 'src/element'
  include 'src/window'
  include 'src/event'
  include 'src/search'

  #
  # The main function of the DOM API, it can take several types of arguments
  #
  # Search:
  #   $('some#css.rule'[, optionally a context]) -> Search
  #
  # Creation:
  #   $('<div>bla bla bla</div>') -> Search
  #
  # DOM-Ready:
  #   $(function() { // dom-ready content // }); -> Document
  #
  # DOM-Wrapper:
  #   $(element)  -> Element
  #   $(document) -> Document
  #   $(window)   -> Window
  #   ...
  #
  # @param {String|Function|Element|Document} stuff
  # @return {Lovely.Search|Lovely.Wrapper} result
  #
  $ = (value, context) ->
    return value if value is null

    switch typeof(value)
      when 'string'   then return new Search(value, context)
      when 'function' then return $(document).on('ready', value)
      when 'object'   then return wrap(value)

    return value


  # exporting the main classes
  ext $,
    version:  '%{version}'
    Browser:  Browser
    Wrapper:  Wrapper
    Document: Document
    Element:  Element
    Window:   Window
    Event:    Event
    Search:   Search

  return $