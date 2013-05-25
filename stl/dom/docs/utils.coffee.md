Just a bunch of local utility functions

Copyright (C) 2011-2013 Nikolay Nemshilov

```coffee-aside
core     = require('core')
A        = core.A
L        = core.L
ext      = core.ext
trim     = core.trim
bind     = core.bind
Class    = core.Class
isArray  = core.isArray
isObject = core.isObject
isString = core.isString
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


dasherize = (string)->
  string.replace(/([a-z\d])([A-Z]+)/g, '$1-$2').toLowerCase()


# converts arguments into a standard x:NNN, y: NNN hash
dimensions_hash = (args) ->
  hash = {}

  if args.length is 1 and isObject(args[0])
    hash = args[0]
  else
    hash.x = args[0] unless args[0] is null
    hash.y = args[1] unless args[1] is null or args[1] is undefined

  hash


# extracts and evals scripts out of the content string
extract_scripts = (content) ->
  scripts = ""

  content = content.replace /<script[^>]*>([\s\S]*?)<\/script>/img,
    (match, source)-> scripts += source + "\n"; return ''

  [content, scripts]


# evals the script string in the global-scope
global_eval = (script) ->
  new Element('script', text: script).insertTo(HTML) if script
  return # void

if 'execScript' of window
  global_eval = (script)->
    window.execScript(script) if script
    return # void

# ensures that the value is an array
ensure_array = (value) ->
  if isArray(value) then value else [value]


# using a random UID_KEY so we didn't interfere with
# any other librarires, including our owns
UID_KEY = "__lovely_dom_uid_#{new Date().getTime()}"
UID_NUM = 1 # the local uids counter
```

Generates an UID for a raw dom-unit

@param {mixed} raw dom-unit
@return {Number} uid

```coffee-aside
uid = (node) ->
  node[UID_KEY] or (node[UID_KEY] = UID_NUM++)
```

a quick local dom-wrapping interface

@param {mixed} dom-unit
@return {Wrapper} dom-unit

```coffee-aside
wrap = (value) ->
  unless `value == null` or value instanceof Wrapper
    key = value[UID_KEY]
    if key && key of Wrapper_Cache
      return Wrapper_Cache[key]
    else if value.nodeType is 1
      return wrap_element(value)
    else if value.nodeType is 9
      return new Document(value)
    else if `value.target != null`
      return new Event(value)
    else if `value.window != null && value.window === value.window.window`
      return new Window(value)

  return value
```

Quick dom-elements only wrapping

__NOTE__: element must exist and must nodeType 1 !

```coffee-aside
wrap_element = (element)->
  Wrapper_Cache[element[UID_KEY]] || new (Wrapper.find(element))(element)
```
