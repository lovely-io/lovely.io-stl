The smooth scrolling visual effect

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
class Fx.Scroll extends Fx.Attr
```

Overloading the constructor to handle correctly
the `Window` objects

@param {dom.Wrapper} element
@return {Fx.Scroll} this

```coffee-aside
  constructor: (element, options)->
    super element, options

    if @element instanceof $.Window
      document = @element._.document
      @element = document.body || document.documentElement

    return @

# protected

  prepare: (value)->
    attrs = {}

    attrs.scrollLeft = value.x if 'x' of value
    attrs.scrollTop  = value.y if 'y' of value

    super attrs
```
