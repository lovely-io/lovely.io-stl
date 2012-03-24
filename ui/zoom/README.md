# Zoom

Zoom is a lightweight version of a lightbox widget, that works just with
images and zooms them instead of showing the screen locker and lightbox dialog

## Usage

Use the standard link and image markup with the `data-zoom` attribute

    :html
    <a href="image-full.png" data-zoom=""><img src="image-thmb.png"></a>

After that hook this module on your page in any standard way, say by using
the `Lovely` loader

    :js
    Lovely(['zoom'], function(Zoom) {
      // Zoom.Options
    });


It will automatically handle all the clicks on your links marked with the
`data-zoom` attribute

## Events

In addition to the normal DOM events, instances of the `Zoom` class emit
the following events

* `show` - when the widget completely appears on the page (after all the fx)
* `hide` - when the widget was hidden
* `load` - when the image was loaded, but before the widget starts zooming


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov