# Welcome to Legacy!

`Legacy` is a module that contains all sorts of patches and feature replacements
to make the old browsers work.

__NOTE__: DON'T load this module manually. It is getting automatically loaded
by the `dom` module when an old browser it's needed.

## Browsers

This module will be loaded in case of the following browsers

 * Internet Explorer version < 9
 * Firefox version < 3
 * Opera version < 10
 * Safari version < 3
 * Konqueror (everything at this moment)

Basically it's all the browsers that don't provide the `document.querySelector`
feature, plus IE8 which has a lack of various things.


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Vasily Pupkin