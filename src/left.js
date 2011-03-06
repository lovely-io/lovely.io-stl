/**
 * LeftJS is as left as you can imagine
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var LeftJS = function() {

  require('core/util');


  // the main object definition
  return ext(function(something) {

  }, {
    version:    '%{version}',

    // globaly available things
    ext:        ext,
    isString:   isString,
    isNumber:   isNumber,
    isFunction: isFunction,
    isArray:    isArray,
    isObject:   isObject
  });

}();

