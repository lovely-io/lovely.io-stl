#
# This module defines the current browser abilites
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Browser_agent = navigator.userAgent

Browser =
  IE:           'attachEvent' of document && !/Opera/.test(Browser_agent)
  Opera:        /Opera/.test(Browser_agent)
  Gecko:        /Gecko/.test(Browser_agent) && !/KHTML/.test(Browser_agent)
  WebKit:       /AppleWebKit/.test(Browser_agent)
  MobileSafari: /Apple.*Mobile.*Safari/.test(Browser_agent)
  Konqueror:    /Konqueror/.test(Browser_agent)


# a couple of internal markers to handle old browsers
Browser_IS_OLD = !document.querySelector
Browser_OLD_IE = false  # IE < 9

try
  document.createElement('<input/>')
  Browser_IS_OLD = Browser_OLD_IE = true

catch e
  # all normal browsers, including IE9 will fall on that

BROWSER_IE_OPACITY = !('opacity' of HTML.style) && 'filter' of HTML.style


# camelizes dashed strings
camelize = (string) ->
  if string.indexOf('-') is -1 then string
  else string.replace /\-([a-z])/g, (match, letter) ->
    letter.toUpperCase()

# converts arguments into a standard x:NNN, y: NNN hash
dimensions_hash = (args) ->
  hash = {}

  if args.length is 1
    hash = args[0]
  else
    hash.x = args[0] unless args[0] is null
    hash.y = args[1] unless args[1] is null

  hash