# STL DOM Interface

This is the standard `dom` handling package for LovelyIO

## Usage

It is mostly the good old [RightJS](http://rightjs.org) except
there is just one `$` jquery-like function

```js
Lovely(['dom'], function($) {
  $('#my-id')
    .html('<p>trololo</p>')
    .parent().addClass('parent');
});
```

See the API docs for the actual usage information


## License & Copyright

This module is published under the terms of the `MIT` License

Copyright (C) 2011-2012 Nikolay Nemshilov
