/**
 * The AJAX support module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('ajax', function() {
  var ext   = LeftJS.ext,
      Class = LeftJS.Class;

  include('./ajax/ajax');
  include('./ajax/jsonp');
  include('./ajax/iframe');

  LeftJS.Ajax = Ajax;

  return ext(Ajax, {
    version: '%{version}'
  });

});