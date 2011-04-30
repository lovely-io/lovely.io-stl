/**
 * The JavaScript core extensions module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('lang', function() {
  var ext = LeftJS.ext;

  require('src/array');
  require('src/string');
  require('src/number');
  require('src/function');

  return {
    version: '%{version}'
  };
});