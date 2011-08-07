#
# The DOM management module for Lovely IO
#
# Copyright (C) 2011 Nikolay Nemshilov
#

include 'src/utils'
include 'src/browser'
include 'src/search'
include 'src/wrapper'
include 'src/element'
include 'src/element/events'
include 'src/element/styles'
include 'src/element/commons'
include 'src/element/dimensions'
include 'src/element/navigation'
include 'src/element/manipulation'
include 'src/document'
include 'src/window'
include 'src/form'
include 'src/input'
include 'src/event'
include 'src/event/delegation'
include 'src/event/mouseio'
include 'src/event/focusio'
include 'src/event/ready'


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
# @return {Search|Wrapper} result
#
$ = (value, context) ->
  switch typeof(value)
    when 'string'   then return new Search(value, context)
    when 'function' then return $(document).on('ready', value)
    when 'object'   then return wrap(value)

  return value


# registering `Form` and `Input` for dynamic typecasting
Wrapper
  .set("form",     Form)
  .set("input",    Input)
  .set("button",   Input)
  .set("select",   Input)
  .set("textarea", Input)
  .set("optgroup", Input)


# exporting the main units
exports = ext $,
  version:  '%{version}'
  Browser:  Browser
  Wrapper:  Wrapper
  Document: Document
  Element:  Element
  Window:   Window
  Event:    Event
  Form:     Form
  Input:    Input
  Search:   Search
  eval:     global_eval
  uid:      uid