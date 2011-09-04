#
# Just a bunch of local utility functions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
core     = require('core')
A        = core.A
L        = core.L
ext      = core.ext
trim     = core.trim
bind     = core.bind
Class    = core.Class
isArray  = core.isArray
isObject = core.isObject
window   = global
document = window.document
HTML     = document.documentElement
isElement = (value)->
  `value != null && value.nodeType === 1`


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

# ensures that the value is an array
ensure_array = (value) ->
  if isArray(value) then value else [value]


# using a random UID_KEY so we didn't interfere with
# any other librarires, including our owns
UID_KEY = "__lovely_dom_uid_#{new Date().getTime()}"
UID_NUM = 1 # the local uids counter

#
# Generates an UID for a raw dom-unit
#
# @param {mixed} raw dom-unit
# @return {Number} uid
#
uid = (node) ->
  unless UID_KEY of node
    node[UID_KEY] = UID_NUM++

  node[UID_KEY]


#
# a quick local dom-wrapping interface
#
# @param {mixed} dom-unit
# @return {Wrapper} dom-unit
#
wrap = (value) ->
  unless `value == null` or value instanceof Wrapper
    key = uid(value) # trying to use an existing wrapper

    if key of Wrapper.Cache
      value = Wrapper.Cache[key]
    else if value.nodeType is 1
      value = new Element(value)
    else if value.nodeType is 9
      value = new Document(value)
    else if `value.target != null`
      value = new Event(value)
    else if `value.window == value`
      value = new Window(value)

  return value
