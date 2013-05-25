Defines the common class for all the dom-wrappers

Copyright (C) 2011-2013 Nikolay Nemshilov

```coffee-aside
class Wrapper

  _: null # the standard raw dom-unit reference
```

Basic constructor

@param {mixed} raw dom-unit
@return {Wrapper} this

```coffee-aside
  constructor: (dom_unit) ->
    @_ = dom_unit
    Wrapper_Cache[uid(dom_unit)] = @
```

Recast the raw dom unit into the new class

@param {Function} new class
@return {Object} of the new class

```coffee-aside
  cast: (Klass)->
    if @ instanceof Klass
      return @
    else
      new Klass(@_)


NodeList.prototype.cast = (Klass)->
  @length > 0 && @[0].cast(Klass)

Wrapper_Cache = {}
Wrapper_Cache[undefined] = false
```
