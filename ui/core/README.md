# UI Core

This package is the basis for the standard UI library. It provides standard
UI elements like buttons, panels, spinners, etc, plus additional features
for more useful UI related events handling


## UI Events Handling

`UI Core` extends the [dom package](/packages/dom) events handling functionality
and allows you to specify human readable keyboard combinations as the event names

    :javascript
    Lovely(['dom', 'ui'], function($) {
      $(document)
        .on('ctrl-z',       undo_stuff)
        .on('ctrl shift z', redo_stuff)
        .on('ctrl alt del', kill_em_all)
    });

__NOTE__: Firefox still doesn't support `event.keyCode` on non-ascii
keyboard layouts, so non-ascii keyboard combinations won't work in there



## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov