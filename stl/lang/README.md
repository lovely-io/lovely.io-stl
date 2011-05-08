# STL JavaScript Extensions

This is the standard provides the standard JavaScript core
extensions. It adds all the latest JavaScript methods for the
browsers that don't support them, and also creates several
semi-standard methods like {String#endsWith}, {Array#includes},
etc.

## Usage

Install it locally with `lovely install lang` or hook up from
`http://cdn.lovely.io`, and then

    Lovely(['lang'], function() {
      'boo-hoo'.endsWith('-hoo'); // -> true
      [1,2,3,4].includes(2);      // -> true
    });

See the API docs for the actual usage information


## License & Copyright

This module is published under the terms of the `MIT` License

Copyright (C) 2011 Nikolay Nemshilov
