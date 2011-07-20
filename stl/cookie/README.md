# Cookie Module

`Cookie` is a little plugin that helps to deal with browser
cookies in a more civilized way. Basically it's a port of
[RightJS Cookie module](http://rightjs.org/docs/cookie)

    :javascript
    Lovely(['cookie'], function(Cookie) {
      Cookie.set('my-cookie', 'my-value');
      Cookie.get('my-cookie');
      Cookie.remove('my-cookie');
    });

It also automatically converts all your data to JSON and parses it
back when you access your cookies, this way you can save any data
in cookies transparently

    :javascript
    Cookie.set('my-cookie', {
      stuff: [1,2,3]
    });

    Cookie.get('my-cookie'); // -> {stuff: [1,2,3]}

It is also available to use the `Cookie` object as a class

    :javascript
    var data = new Cookie('name', {
      ttl: 2 // days
    });

    data.set('value');
    data.get();    // -> 'value'
    data.remove();


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov