/**
 * LeftJS is as left as you can imagine
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var LeftJS = function(undefined) {

  include('./core/left');
  include('./core/util');
  include('./core/class');
  include('./core/list');
  include('./core/hash');


  // exporting the globally visible objects
  return ext(LeftJS, {
    version:     '%{version}',

    // the loader default options
    modules:     {}, // the loaded modules index
    loading:     {}, // the currently loading modules
    baseUrl:     '', // default base url address for local modules
    hostUrl:     '', // default host url address for LeftJS modules
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


