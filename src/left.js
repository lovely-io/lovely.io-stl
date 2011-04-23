/**
 * LeftJS is as left as you can imagine
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var LeftJS = function(undefined) {

  require('core/util');
  require('core/class');
  require('core/list');
  require('core/hash');
  require('core/load');


  /**
   * the main object definition
   *
   * @param {mixed} something
   * @return {mixed} something else
   */
  function LeftJS(something) {
    load.apply(this, arguments);
  }

  // attaching globally accessible functions
  return ext(LeftJS, {
    version:    '%{version}',

    A:          A,
    L:          L,
    H:          H,
    ext:        ext,
    isString:   isString,
    isNumber:   isNumber,
    isFunction: isFunction,
    isArray:    isArray,
    isObject:   isObject,
    Class:      Class,
    List:       List,
    Hash:       Hash,
    modules:    loaded_modules
  });

}();


