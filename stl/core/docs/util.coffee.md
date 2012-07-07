Utility functions for Lovely IO

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
Object_toString = Object.prototype.toString
Array_slice     = Array.prototype.slice
Function_bind   = Function.prototype.bind || ->
  args    = A(arguments)
  context = args.shift()
  method  = this

  return ->
    method.apply(context, args.concat(A(arguments)))

String_trim     = String.prototype.trim || ->
  str = this.replace(/^\s\s*/, '')
  i   = str.length
  re  = /\s/
  `while (re.test(str.charAt(--i))) {}`
  str.slice(0, i + 1)
```

Converts iterables into arrays

@param {mixed} iterable
@return {Array} array

```coffee-aside
A = (it) -> Array_slice.call(it, 0)
```

Converts iterables into Lovely.List instances

@param {mixed} iterable
@return {List} list

```coffee-aside
L = (it) -> new List(it)
```

A shortcut to create {Hash} instances

@param {Object} object
@return {Hash} hash

```coffee-aside
H = (object) -> new Hash(object)
```

Extends one object with another

@param {Object} extendee
@param {Object} extender (null and undefined is acceptable)
@return {Object} extendee

```coffee-aside
ext = (one, another) ->
  `another == null && (another = {})`

  for own key of another
    one[key] = another[key]

  return one
```

Binds the function with the context

@param {Function} function
@param {Object} context
@param {mixed} argument
.....
@return {Function} proxy

```coffee-aside
bind = ->
  args = A(arguments)
  Function_bind.apply(args.shift(), args)
```

Trims the exessive spaces from the beginning
and the end of the string

@param {String} original string
@return {String} trimmed string

```coffee-aside
trim = (string) -> String_trim.call(string)
```

Checks if the given value is a string

@param {mixed} something
@return {boolean} check result

```coffee-aside
isString = (value) -> typeof(value) is 'string'
```

Checks if the given value is a number

@param {mixed} something
@return {boolean} check result

```coffee-aside
isNumber = (value) -> typeof(value) is 'number' and !isNaN(value)
```

Checks if the given value is a function

@param {mixed} some value
@return {boolean} check result

```coffee-aside
isFunction = (value) -> typeof(value) is 'function' and Object_toString.call(value) isnt '[object RegExp]'
```

Checks if the given value is an array

@param {mixed} some value
@return {boolean} check result

```coffee-aside
isArray = (value) -> Object_toString.call(value) is '[object Array]' or value instanceof List
```

Checks if the given value is a plain object

@param {mixed} some value
@return {boolean} check result

```coffee-aside
isObject = (value) -> Object_toString.call(value) is '[object Object]'


# private
```

Checks if the value is an array then returns it,
otherways make an one cell array with that value

@param {mixed} some value
@return {Array} array

```coffee-aside
ensure_Array = (value) ->
  if isArray(value) then value else [value]
```
