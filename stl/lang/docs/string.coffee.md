String class extensions

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
ext String.prototype,
```

Checks if the string is an empty string

@return {Boolean} check result

```coffee-aside
  empty: -> `this == ''`
```

Checks if the string contains only white-spaces

@return {Boolean} check result

```coffee-aside
  blank: -> `this == false`
```

Removes trailing whitespaces

@return {String} trimmed version

```coffee-aside
  trim: String.prototype.trim || ->
    str = @replace(/^\s\s*/, ''); i = str.length
    while ((/\s/).test(str.charAt(i-=1)))
      ;
    str.slice(0, i + 1)
```

Returns a copy of the string with all the tags removed

@return {String} without tags

```coffee-aside
  stripTags: ->
    @replace /<\/?[^>]+>/ig, ''
```

Converts underscored or dasherized string to a camelized one

@returns {String} camelized version

```coffee-aside
  camelize: ->
    @replace /(\-|_)+(.)?/g, (match, dash, chr)->
      if chr then chr.toUpperCase() else ''
```

Converts a camelized or dasherized string into an underscored one

@return {String} underscored version

```coffee-aside
  underscored: ->
    @replace(/(^|[a-z\d])([A-Z]+)/g, '$1_$2').replace(/\-/g, '_').toLowerCase()
```

Converts the string into a dashed string

@return {String} dasherized version

```coffee-aside
  dasherize: ->
    @underscored().replace(/_/g, '-')
```

Returns a capitalised version of the string

@return {String} captialised version

```coffee-aside
  capitalize: ->
    @charAt(0).toUpperCase() + @substring(1).toLowerCase()
```

Checks if the string contains the given substring

@param {String} a substring
@return {Boolean} check result

```coffee-aside
  includes: (string) ->
    @indexOf(string) isnt -1
```

Checks if this string ends with the given substring

@param {String} a sbustring
@return {Boolean} check result

```coffee-aside
  endsWith: (substring)->
    (@length - @lastIndexOf(substring)) is substring.length
```

Checks if the string starts with the given substring

@param {String} a substring
@return {Boolean} check result

```coffee-aside
  startsWith: (substring)->
    @indexOf(substring) is 0
```

Converts the string into an itenteger value

@param {Integer} convertion base, default 10
@return {Integer|NaN} result

```coffee-aside
  toInt: (base)->
    parseInt(this, if base is undefined then 10 else base)
```

Converts the string into a float value

@return {Float|NaN} result

```coffee-aside
  toFloat: ->
    parseFloat(this)
```
