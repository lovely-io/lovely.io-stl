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
    });

## Automatic Initialization

You can use the standard automatic initialization by the `data-draggable` HTML5 attribute

    :html
    <div data-draggable="{options: 'here'}">
      Drag and drop me!
    </div>

Specify your draggable unit options in JSON format, or just leave `{}` in there


## DND Events

This module fires a bunch of additional events when the user interacts with the draggable
and droppable elements

 * beforedrag
 * dragstart
 * drag
 * dragend
 * dragleave
 * dragover
 * drop



## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov