# DND

`DND` is the HTML5 based drag-n-drop feature extension for the [dom module](/packages/dom)

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

## DND Events


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov