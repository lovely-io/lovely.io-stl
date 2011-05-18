#
# Just a bunch of local utility functions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Lovely   = require('core')
A        = Lovely.A
L        = Lovely.L
ext      = Lovely.ext
trim     = Lovely.trim
bind     = Lovely.bind
Class    = Lovely.Class
isArray  = Lovely.isArray
window   = global
document = window.document
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


# using IE's native 'uniqNumber' sequencer when available
if 'uniqNumber' of HTML
  uid = (node) ->
    if node.nodeType is 1
      return node.uniqNumber
    else
      # document and window objects don't have the `uniqNumber` property
      # so we hack it around by using negative indexes and our own
      # internal random UID_KEY property
      unless UID_KEY of node
        node[UID_KEY] = -1 * UID_NUM++

    node[UID_KEY]

#
# a quick local dom-wrapping interface
#
# @param {mixed} dom-unit
# @return {Wrapper} dom-unit
#
wrap = (value) ->
  if `value != null`
    key = uid(value) # trying to use an existing wrapper

    if key of Wrapper.Cache
      return Wrapper.Cache[key]
    else if value.nodeType is 1
      return new Element(value)
    else if value.target || value.srcElement
      return new Event(value)
    else if value.nodeType is 9
      return new Document(value)
    else if `value.window == value`
      return new Window(value)

  return value # in case it's already wrapped or just `null`
