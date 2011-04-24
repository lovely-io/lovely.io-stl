/**
 * LeftJS is as left as you can imagine
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var LeftJS = function(undefined) {

  require('core/left');
  require('core/util');
  require('core/class');
  require('core/list');
  require('core/hash');


  // exporting the globally visible objects
  return ext(LeftJS, {
    version:     '%{version}',

    // the loader default options
    modules:     {}, // the loaded modules index
    baseUrl:     '', // default base url address
    waitSeconds: 8,  // timeout before give up on a module

    // globally accessible functions
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
    Hash:       Hash
  });

}();


