# Lovely Core Module

This is the main module of Lovely IO, it provides the asynchronous
modules loading/definition functionality with all the automatic
dependencies management.

This module also contains a collection of basic utility functions
and main OOP units like `Class`, `Observer`, `Options`


## Initializing and Loading

Basic scripts initialization is pretty simple

    :html
    <html>
      <head>
        <script src="http://cdn.lovely.io/core.js"></script>
        <script type="text/javascript">
          Lovely(['dom', 'ajax', 'fx'], function($, ajax, fx) {
            ajax.load('/my.url', {
              complete: function() {
                $('#content').html(this.text).highlight();
              }
            });
          });
        </script>
      </head>
      <body>
        <div id="content">Loading...</div>
      </body>
    </html>


## Versions Bundling

You can specify which versions of packages should be used by default by
using the bundling config

    :javascript
    Lovely.bundle = {
      'dom'  : '1.2.0',
      'ajax' : '1.1.0'
    };

After that you can use just package names like `'dom'` and `'ajax'` and
lovely will automatically use package versions specified in the bundler config.


## Utility Functions

See the API docs


## License & Copyright

This project is published under the terms of the `MIT` license.

Copyright (C) 2011 Nikolay Nemshilov