#
# The draggable part of the unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Draggable =
  # default options
  Options:
    handle:            null       # a handle element that will start the drag

    snap:              0          # a number in pixels or [x,y]
    axis:              null       # null or 'x' or 'y' or 'vertical' or 'horizontal'
    range:             null       # {x: [min, max], y: [min, max]} or reference to another element

    dragClass:         'dragging' # the in-process class name

    clone:             false      # if should keep a clone in place
    revert:            false      # marker if the object should be moved back on finish
    revertDuration:    'normal'   # the moving back fx duration

    scroll:            true       # if it should automatically scroll
    scrollSensitivity: 32         # the scrolling area size in pixels

    zIndex:            999999999  # the element's z-index
    moveOut:           false      # marker if the draggable should be moved out of it's context (for overflown

  # currently dragged element reference
  current: null

  #
  # Switches on/off the draggability
  #
  # @param {Object|Boolean} options or `true|false` to switch on/off
  # @return {Element} this
  #
  draggable: (options)->
    if options is false
      delete(@__draggable)
    else if !('__draggable' of @)
      @__draggable = make_draggable(this, options)

    return @


# private

# x,y offsets from the cursor and relative scope
draggable_offset_x  = 0
draggable_offset_y  = 0
draggable_offset_rx = 0
draggable_offset_ry = 0

#
# Makes a draggable unit
#
# @param
#
make_draggable = (element, options)->
  options = merge('draggable', element, options)

  # finding the handle element
  options.handle = $(options.handle) if isString(options.handle)
  options.handle = options.handle[0] if isArray(options.handle)
  options.handle = options.handle || element

  if isArray(options.snap)
    options.snapX = options.snap[0]
    options.snapY = options.snap[1]
  else
    options.snapX = options.snapY = options.snap || 0

  options.axisX = options.axis in ['x', 'horizontal']
  options.axisY = options.axis in ['y', 'vertical']

  return options

#
# Precalculates the movement constraints
#
draggable_calc_constraints = (element, options)->
  options.ranged = false
  if range = options.range
    options.ranged = true

    # if the range is defined by another element
    range_element = $(range)

    if range_element.position
      position = range_element.position()
      range =
        x: [position.x, position.x + range_element.size().x]
        y: [position.y, position.y + range_element.size().y]


    if isObject(range)
      if 'x' of range
        options.minX = range.x[0]
        options.maxX = range.x[1] - element.size().x

      if 'y' of range
        options.minY = range.y[0]
        options.maxY = range.y[1] - element.size().y

  return #nothing


#
# Starts the drag process
#
# @param {dom.Event} event
# @param {dom.Element} draggable
#
draggable_start = (event, element)->
  return if event.which isnt 1 # triggered only by right click

  event.type = 'beforedragstart'
  element.emit event

  droppable_prepare_targets()

  options  = element.__draggable
  position = element.position()

  # getting the cursor position offset
  draggable_offset_x = event.pageX - position.x
  draggable_offset_y = event.pageY - position.y

  # grabbing the relative position diffs for nested spaces
  draggable_offset_rx = 0
  draggable_offset_ry = 0

  parent = element.parent()

  while parent instanceof $.Element
    if parent.style('position') isnt 'static'
      parent = parent.position()
      draggable_offset_rx = parent.x
      draggable_offset_ry = parent.y
      break

    parent = parent.parent()

  # preserving the element sizes
  size = element.style('width,height')
  size.width  = element.size().x + 'px' if size.width  is 'auto'
  size.height = element.size().y + 'px' if size.height is 'auto'

  # building a clone element if necessary
  if options.clone or options.revert
    options._clone = element.clone().style({
      visibility: if options.clone then 'visible' else 'hidden'
    }).insertTo(element, 'after')

  # reinserting the element to the body so it was over all the other elements
  element.style({
    position: 'absolute',
    zIndex:   Draggable.Options.zIndex++,
    top:      position.y - draggable_offset_ry + 'px',
    left:     position.x - draggable_offset_rx + 'px',
    width:    size.x,
    height:   size.y
  }).addClass(options.dragClass)

  element.insertTo(document.body) if options.moveOut

  # caching the window scrolls
  options.winScrolls = $(window).scrolls();
  options.winSizes   = $(window).size();

  draggable_calc_constraints(element, options)

  Draggable.current  = element
  element.emit('dragstart')


#
# Moves the draggable unit
#
# @param {dom.Event} event
# @param {dom.Element} draggable
#
draggable_move = (event, element)->
  options = element.__draggable
  page_x  = event.pageX
  page_y  = event.pageY
  x = page_x - draggable_offset_x
  y = page_y - draggable_offset_y

  # checking the range
  if options.ranged
    x = options.minX if options.minX > x
    x = options.maxX if options.maxX < x
    y = options.minY if options.minY > y
    y = options.maxY if options.maxY < y

  # checking the scrolls
  if options.scroll
    scrolls     = x: options.winScrolls.x, y: options.winScrolls.y
    sensitivity = options.scrollSensitivity

    if (page_y - scrolls.y) < sensitivity
      scrolls.y = page_y - sensitivity
    else if (scrolls.y + options.winSizes.y - page_y) < sensitivity
      scrolls.y = page_y - options.winSizes.y + sensitivity

    if (page_x - scrolls.x) < sensitivity
      scrolls.x = page_x - sensitivity
    else if (scrolls.x + options.winSizes.x - page_x) < sensitivity
      scrolls.x = page_x - options.winSizes.x + sensitivity

    scrolls.y = 0 if scrolls.y < 0
    scrolls.x = 0 if scrolls.x < 0

    if scrolls.y < options.winScrolls.y || scrolls.y > options.winScrolls.y ||
       scrolls.x < options.winScrolls.x || scrolls.x > options.winScrolls.x

        $(window).scrolls(options.winScrolls = scrolls)

  # checking the snaps
  x = x - x % options.snapX if options.snapX
  y = y - y % options.snapY if options.snapY

  # checking the constraints
  element._.style.left = x - draggable_offset_rx + 'px' unless options.axisY
  element._.style.top  = y - draggable_offset_ry + 'px' unless options.axisX

  event.type = 'drag'
  element.emit event


#
# Finishes the drag
#
# @param {dom.Event} event
# @param {dom.Element} element
#
draggable_drop = (event, element)->
  options = element.__draggable
  element.removeClass(options.dragClass)

  # notifying the droppables for the drop
  droppable_check_drop(event, element)

  if options.revert
    draggable_revert(element, options)
  else
    Draggable.current = null

  event.type = 'dragend'
  element.emit(event)


#
# Moves the element's position and size back
#
# @param {dom.Element} element
# @param {Object} options
#
draggable_revert = (element, options)->
  position  = options._clone.position();
  end_style =
    top:  position.y - draggable_offset_ry + 'px'
    left: position.x - draggable_offset_rx + 'px'

  if options.revertDuration and element.animate
    element.animate end_style,
      duration: options.revertDuration
      finish:   -> draggable_swap_back(element, options)
  else
    element.style(end_style)
    draggable_swap_back(element, options)

  return # nothing


#
# Swaps back the element and it's clone
#
# @param {dom.Element} element
# @param {Object} options
#
#
draggable_swap_back = (element, options)->
  if options._clone
    element.style options._clone.style('width,height,position,zIndex')
    options._clone.replace(element)

  Draggable.current = null