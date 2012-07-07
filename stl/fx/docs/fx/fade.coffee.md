The standard opacity visual effect

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
class Fx.Fade extends Fx.Twin

# protected

  prepare: (direction)->
    @setDirection(direction)

    if @direction is 'in'
      # calling 'prototype' to prevent circular calls from subclasses
      Element.prototype.show.call(@element.style({opacity: 0}))

    super opacity: if @direction is 'in' then 1 else 0
```
