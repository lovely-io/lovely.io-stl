#
# This module defines the current browser abilites
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Browser = 'Unknown'

# a dummy browser guess by the userAgent parameter
Browser_agent = navigator.userAgent

Browser = 'IE'           if 'attachEvent' of document && !/Opera/.test(Browser_agent)
Browser = 'Opera'        if /Opera/.test(Browser_agent)
Browser = 'Gecko'        if /Gecko/.test(Browser_agent) && !/KHTML/.test(Browser_agent)
Browser = 'WebKit'       if /AppleWebKit/.test(Browser_agent)
Browser = 'MobileSafari' if /Apple.*Mobile.*Safari/.test(Browser_agent)
Browser = 'Konqueror'    if /Konqueror/.test(Browser_agent)


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


# extracts and evals scripts out of the content string
extract_scripts = (content) ->
  scripts = ""

  content = content.replace /<script[^>]*>([\s\S]*?)<\/script>/img,
    (match, source)-> scripts += source + "\n"

  [content, scripts]


# evals the script string in the global-scope
global_eval = (script) ->
  new Element('script', text: script).insertTo(HTML) if script

# IE has a native global eval function
global_eval = window.execScript if window.execScript