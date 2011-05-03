/**
 * The AJAX support module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS(function() {
  var ext   = LeftJS.ext,
      Class = LeftJS.Class;

  include('src/ajax');
  include('src/jsonp');
  include('src/iframe');

  LeftJS.Ajax = Ajax;

  return ext(Ajax, {
    version: '%{version}'
  });

});