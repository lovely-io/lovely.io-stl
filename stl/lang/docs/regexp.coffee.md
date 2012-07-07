The `RegExp` unit extensions

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
```

Escapes the string for safely use as a regular expression

@param {String} raw string
@return {String} escaped string

```coffee-aside
RegExp.escape = (string)->
  (''+string).replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1')
```
