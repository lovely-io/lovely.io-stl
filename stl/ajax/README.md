# STL Ajax Module

This package provides the standard `ajax` functionality


## Usage

Install it locally with `lovely install ajax` or hook up from
`http://cdn.lovely.io`

    :javascript
    Lovely(['ajax'], function(ajax) {
      ajax.get('/my.url', {
        success:  function() { /* ... */ },
        failure:  function() { /* ... */ },
        complete: function() { /* ... */ }
      });
    });


## License & Copyright

This module is published under the terms of the `MIT` License

Copyright (C) 2011-2012 Nikolay Nemshilov
