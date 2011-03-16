/**
 * LeftJS is as left as you can imagine
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var LeftJS = function() {

  require('core/util');
  require('core/class');


  /**
   * the main object definition
   *
   * @param {mixed} something
   * @return {mixed} something else
   */
  function LeftJS(something) {
    // TODO: converting something into something else
  }

  // attaching globally accessible functions
  return ext(LeftJS, {
    version:    '%{version}',

    A:          A,
    ext:        ext,
    isString:   isString,
    isNumber:   isNumber,
    isFunction: isFunction,
    isArray:    isArray,
    isObject:   isObject,
    Class:      Class
  });

}();


