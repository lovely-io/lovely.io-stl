/**
 * The JavaScript core extensions module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('lang', function() {
  var ext = LeftJS.ext;

  require('lang/array');
  require('lang/string');
  require('lang/number');
  require('lang/function');

  return {
    version: '%{version}'
  };
});