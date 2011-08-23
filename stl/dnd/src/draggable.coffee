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
  additional = new Function("return #{element.attr('data-draggable')}")();
  options    = Hash.merge(Draggable.Options, additional, options)

  # finding the handle element
  options.handle = $(options.handle) if isString(options.handle)
  options.handle = options.handle[0] if isArray(options.handle)
  options.handle = options.handle || element

  if isArray(options.snap)
    options.snapX = options.snap[0]
    options.snapY = options.snap[1]
  else
    options.snapX = options.snapY = options.snap || 0

  return options


#
# Starts the drag process
#
# @param {dom.Event} event
# @param {dom.Element} draggable
#
draggable_start = (event, element)->
  element.emit('beforedragstart')

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
    }).insertTo(element, 'before')

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

  Draggable.current  = element
  element.emit('dragstart')


#
# Moves the draggable unit
#
# @param {dom.Event} event
# @param {dom.Element} draggable
#
draggable_move = (event, element)->
  console.log("Moving")

#
# Finishes the drag
#
# @param {dom.Event} event
# @param {dom.Element} element
#
draggable_drop = (event, element)->
  Draggable.current = null
  element.emit('dragend')
  console.log("Drop")

