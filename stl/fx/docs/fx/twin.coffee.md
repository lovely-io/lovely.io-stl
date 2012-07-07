An abstract class for bidirectional visual effects

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
class Fx.Twin extends Fx.Style
```

Hidding the element after the effect

@return {Fx.Twin} this

```coffee-aside
  finish: ->
    if @direction is 'out'
      # calling 'prototype' to prevent circular calls from subclasses
      Element.prototype.hide.call(@element)

    super


# protected
```

Picking up the direction

```coffee-aside
  setDirection: (direction)->
    if !direction or direction is 'toggle'
      direction = if @element.visible() then 'out' else 'in'

    @direction = direction

    return;
```
