Hash '#toQueryString' method

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
Hash.include
  toQueryString: ->
    tokens = []

    @forEach (key, value)->
      if isArray(value)
        key += "[]" unless key.substr(key.length - 2) is '[]'

      else if isObject(value)
        for name of value
          tokens.push("#{encodeURIComponent(key+"["+name+"]")}=#{encodeURIComponent(value[name])}")

        value = []

      else
        value = [value]

      for token in value
        tokens.push("#{encodeURIComponent(key)}=#{encodeURIComponent(token)}")

    tokens.join('&')
```

Parses a query-string and converts it
into a normal hash

```coffee-aside
Hash.fromQueryString = (string)->
  hash = {}
  for token in (string || '').split('&')
    if token.indexOf('=') isnt -1
      [key, value] = token.split('=')

      # converting arrays
      if key.substr(key.length - 2) is '[]'
        key = key.substr(0, key.length - 2)
        hash[key] or= []
        hash[key].push(value)

      # converting hashes
      else if match = key.match(/^(.+?)\[([^\]]+)\]$/)
        key = match[1]
        hash[key] or= {}
        hash[key][match[2]] = value

      # assigning plain key-values
      else
        hash[key] = value
  hash
```
