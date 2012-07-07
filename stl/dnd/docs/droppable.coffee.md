The droppable targets functionality

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
Droppable =
  Options:
    accept:      '*'   # css-class, or list of css-classes or list of elements of accepted draggables

    overlap:     false # 'x', 'y', 'horizontal', 'vertical', 'both'  makes it respond only if the draggable overlaps the droppable
    overlapSize: 0.5   # the overlapping level 0 for nothing 1 for the whole thing

    allowClass:  'droppable-allow' # added when an acceptable draggable hovers the target
    denyClass:   'droppable-deny'  # added when an inacceptable draggable enters the target

  current: null # the currently hovered droppable
```

The element's method to turn the droppable
functionality on and off

@param {Object|Boolean} options or `false` to switch off
@return {dom.Element} this

```coffee-aside
  droppable: (options)->
    if options is false
      delete(@__droppable)
    else if !('__droppable' of @)
      @__droppable = merge('droppable', @, options)
      droppable_targets.push(@)

    return @

# private

# list of droppable targets, populated when a drag starts
droppable_targets = []
```

Activates all the droppable targets on the page

@return void

```coffee-aside
droppable_prepare_targets = ->
  $('*[data-droppable]').map('droppable')
```

Checks the dragenter/dragleave events

@param {dom.Event} mouse-move event
@param {dom.Element} the draggable

```coffee-aside
droppable_hover = (event, draggable)->
  overloap         = null
  event_position   = event.position()
  element_position = draggable.position()
  element_size     = draggable.size()

  for target in droppable_targets
    if droppable_overlaps(target, event_position, element_position, element_size)
      overlap = target
      break

  if overlap and Droppable.current is null
    options = overlap.__droppable

    if droppable_acceptable(Draggable.current, overlap)
      overlap.addClass options.allowClass
    else
      overlap.addClass options.denyClass

    Droppable.current = overlap

    overlap.emit 'dragenter', draggable: Draggable.current, droppable: Droppable.current

  else if !overlap and Droppable.current isnt null
    droppable_revert()

    Droppable.current.emit 'dragleave', draggable: Draggable.current, droppable: Droppable.current
    Droppable.current = null
```

Checks if draggable and droppable overlap

@param {dom.Element} droppable
@param {Object} event position
@param {Object} draggable position
@return {Object} draggable size

```coffee-aside
droppable_overlaps = (target, e_pos, d_pos, d_size)->
  options  = target.__droppable
  level    = options.overlapSize
  top      = d_pos.y
  left     = d_pos.x
  right    = left + d_size.x
  bottom   = top  + d_size.y
  t_pos    = target.position()
  t_size   = target.size()
  t_top    = t_pos.y
  t_left   = t_pos.x
  t_right  = t_left + t_size.x
  t_bottom = t_top  + t_size.y

  if options.overlap is false # simply check agains the event position
    return e_pos.x > t_left && e_pos.x < t_right && e_pos.y > t_top && e_pos.y < t_bottom
  else
    switch options.overlap
      when 'x', 'horizontal' # horizontal overlap check
        return (
          (top    > t_top    && top     < t_bottom) ||
          (bottom > t_top    && bottom  < t_bottom)
        ) && (
          (left   > t_left   && left    < (t_right - t_size.x * level)) ||
          (right  < t_right  && right   > (t_left  + t_size.x * level))
        )
      when 'y', 'vertical' # vertical overlap check
        return (
          (left   > t_left   && left   < t_right) ||
          (right  > t_left   && right  < t_right)
        ) && (
          (top    > t_top    && top    < (t_bottom - t_size.y * level)) ||
          (bottom < t_bottom && bottom > (t_top    + t_size.y * level))
        )
      else # both side overlap check
        return (
          (left   > t_left   && left   < (t_right  - t_size.x * level)) ||
          (right  < t_right  && right  > (t_left   + t_size.x * level))
        ) && (
          (top    > t_top    && top    < (t_bottom - t_size.y * level)) ||
          (bottom < t_bottom && bottom > (t_top    + t_size.y * level))
        )
```

Checks if the draggable is acceptable by the drooppable

@param {dom.Element} draggable
@param {dom.Element} droppable
@return {Boolean} check result

```coffee-aside
droppable_acceptable = (draggable, droppable)->
  options = droppable.__droppable

  if options.accept is '*'
    return true
  else
    rules = options.accept
    rules = [rules] unless isArray(rules)
    for rule in rules
      rule = $(rule) if isString(rule)
      rule = [rule] unless isArray(rule)

      for element in rule
        if element._ is draggable._
          return true

  return false
```

Reverts a droppable state, when something was dropped
or draggable just left the target

```coffee-aside
droppable_revert = ->
  overlap = Droppable.current
  options = overlap.__droppable

  overlap.removeClass options.allowClass
  overlap.removeClass options.denyClass
```

Checks if the droppable was dropped over a target and fires the events

@param {dom.Event} the original mouseup event
@param {dom.Element} the draggable element

```coffee-aside
droppable_check_drop = (event, draggable)->
  if Droppable.current isnt null
    droppable_revert()

    if droppable_acceptable(draggable, Droppable.current)
      Droppable.current.emit 'drop', draggable: draggable, droppable: Droppable.current

  return # nothing
```
