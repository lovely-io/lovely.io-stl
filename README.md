# Lovely IO

`LeftJS` is a clean take on the [RightJS](http://rightjs.org) framework

It is not a fork, it is more like R&D for the future major version of
RightJS. The goal is to play with some new ideas in a clean environment.

The targets are the following:

 * Get rid of all the global variables
 * Make no JavaScript core extensions (will go in a plugin)
 * Create a console based testing/building environment
 * Make more civilized collections handling interface
 * Review the utility functions collection
 * Focus on the modern browsers: Safari, Chrome, FF4
 * Zero tolerance for old browser hacks in the core

Basically the aim is to create a super-lightweight and clean version of
RightJS and see where it will get us.


## How To...

You'll need `node`, `npm` and then install the following packages

    npm install nake vows jshint uglify-js express zombie

After that just run one of those

    nake build
    nake test
    nake test:spec
    nake check



## License & Copyright

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov