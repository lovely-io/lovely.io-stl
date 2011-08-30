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