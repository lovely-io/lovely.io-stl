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

## Utility Functions

See the API docs


## License & Copyright

This project is published under the terms of the `MIT` license.

Copyright (C) 2011 Nikolay Nemshilov