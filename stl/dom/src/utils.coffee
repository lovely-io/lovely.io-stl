#
# Just a bunch of local utility functions
#
# Copyright (C) 2011 Nikolay Nemshilov
#

A        = Lovely.A
ext      = Lovely.ext
trim     = Lovely.trim
bind     = Lovely.bind
Class    = Lovely.Class
window   = this
document = this.document
HTML     = document.documentElement


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