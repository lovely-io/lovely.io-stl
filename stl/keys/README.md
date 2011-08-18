# Keys

`Keys` is a little helper for the [dom package](/packages/dom) that allows
you to specify human readable keyboard combinations as the event names

    :javascript
    Lovely(['dom', 'keys'], function($) {
      $(document)
        .on('ctrl-z',       undo_stuff)
        .on('ctrl shift z', redo_stuff)
        .on('ctrl alt del', kill_em_all)
    });

__NOTE__: Firefox still doesn't support `event.keyCode` on non-ascii
keyboard layouts, so non-ascii keyboard combinations won't work in there


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov