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

    zIndex:            10000000   # the element's z-index
    moveOut:           false      # marker if the draggable should be moved out of it's context (for overflown

  # currently dragged element reference
  current: null

  #
  # Switches on/off the draggability
  #
  # @param {Object|Boolean} options or `false` to switch off
  # @return {Element} this
  #
  draggable: (options)->
    if options is false
      if '__draggable' of @
        @no('mousedown', @__draggable)
    else
      @on('mousedown', @__draggable = make_draggable(this, options))

    return @


# private

#
# Makes a draggable unit
#
# @param
#
make_draggable = (element, options)->
  options = merge(Draggable.Options, element.attr('data-draggable'), options)

  draggable = (event)->
    # finding the handle element
    options.handle   = $(options.handle) if isString(options.handle)
    options.handle   = options.handle[0] if isArray(options.handle)
    draggable.handle = options.handle || element

    # prefetching the snap options
    if isArray(options.snap)
      draggable.snapX = options.snap[0]
      draggable.snapY = options.snap[1]
    else
      draggable.snapX = draggable.snapY = options.snap || 0

    # initializing the actual drag
    draggable_start(event, draggable)
    Draggable.current = draggable

  ext draggable, options: options, element: element


#
# Starts the drag process
#
# @param {dom.Event} event
# @param {draggable} unit
#
draggable_start = (event, draggable)->
  console.log("Start")

#
# Moves the draggable unit
#
# @param {dom.Event} event
# @param {draggable} unit
#
draggable_move = (event, draggable)->

#
# Finishes the drag
#
# @param {dom.Event} event
# @param {draggable} unit
#
draggable_drop = (event, draggable)->
  console.log("Drop")

