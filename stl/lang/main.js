/**
 * The JavaScript core extensions module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS(function() {
  var ext = LeftJS.ext;

  include('src/array');
  include('src/string');
  include('src/number');
  include('src/function');

  return {
    version: '%{version}'
  };
});