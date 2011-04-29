/**
 * The JavaScript core extensions module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('lang', function() {
  var ext = LeftJS.ext;

  include('./lang/array');
  include('./lang/string');
  include('./lang/number');
  include('./lang/function');

  return {
    version: '%{version}'
  };
});