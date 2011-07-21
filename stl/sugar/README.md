# STL Syntax Sugar

This module provides some syntax sugar features for the `dom` module.
Basically those are the `onEventname` shortcuts for dom wrappers.

    :javascript
    $('div.something').onClick('toggleClass', 'clicked');

    new Element('div').onMouseover(function(event) {
      // do something
    });


This package also provides quick `String#toSomething()` shortcuts

    :javascript
    "div.something".html();

    // same as
    $("div.something").html();

And quick UJS definitions

    :javascript
    "div.something".on('click', 'toggleClass', 'marked');

    // same as
    $(document).delegate('div.something', 'click', 'toggleClass', 'marked');


## License & Copyright

This module is published under the terms of the `MIT` License

Copyright (C) 2011 Nikolay Nemshilov
