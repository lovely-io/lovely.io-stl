# DND

`DND` is the drag-n-drop feature extension for the [dom module](/packages/dom)

    :javascript
    Lovely(['dom', 'dnd'], function($) {
      $('#my-element').draggable({
        // some options
      });
      $('#my-element').droppable({
        // some options
      });

      // to remove the functionality call those
      $('#my-element').draggable(false);
      $('#my-element').droppable(false);

      // same thing for droppables
      $('#another-element').droppable({
        accept: 'div.red'
      })

      // switch off
      $('#another-element').droppable();
    });

## Automatic Initialization

You can use the standard automatic initialization by the `data-draggable` HTML5 attribute

    :html
    <div data-draggable="{revert: true}">
      Drag and drop me!
    </div>

    <div data-droppable="{accept: 'div.red'}">
      Reds only!
    </div>

In this case the element will be initialized automatically when the user _starts_
to interact with it. Just specify your draggable unit options in the `JSON` format,
or leave `{}` in the attribute.

## Options

The following options are available with the `draggable` method

 * `handle`            (null)       - a handle element that will start the drag
 * `snap`              (0)          - a number in pixels or [x,y]
 * `axis`              (null)       - null or 'x' or 'y' or 'vertical' or 'horizontal'
 * `range`             (null)       - {x: [min, max], y: [min, max]} or reference to another element
 * `dragClass`         ('dragging') - the in-process class name
 * `clone`             (false)      - if should keep a clone in place
 * `revert`            (false)      - marker if the object should be moved back on finish
 * `revertDuration`    ('normal')   - the moving back fx duration
 * `scroll`            (true)       - if it should automatically scroll
 * `scrollSensitivity` (32)         - the scrolling area size in pixels
 * `moveOut`           (false)      - marker if the draggable should be moved out of it's context (for overflown

The following options are available with the `droppable` method

 * `accept`      ('*')   - css-class, or a list of css-classes or list of elements of accepted draggables
 * `overlap`     (false) - 'x', 'y', 'horizontal', 'vertical', 'both'  makes it respond only if the draggable overlaps the droppable
 * `overlapSize` (0.5)   - the overlapping level 0 for nothing 1 for the whole thing
 * `allowClass`  ('droppable-allow') - added when an acceptable draggable hovers the target
 * `denyClass`   ('droppable-deny')  - added when an inacceptable draggable enters the target


## DND Events

This module fires a bunch of additional events when the user interacts with the draggable
and droppable elements

 * beforedrag
 * dragstart
 * drag
 * dragend
 * dragenter
 * dragleave
 * drop

Event listeners can be attached to the elements directly using the standard `Element#on`
method, or specified along with the options


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov