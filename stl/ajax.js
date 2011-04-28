/**
 * The AJAX support module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('ajax', function() {
  var ext   = LeftJS.ext,
      Class = LeftJS.Class;

  require('ajax/ajax');
  require('ajax/jsonp');
  require('ajax/iframe');

  LeftJS.Ajax = Ajax;

  return ext(Ajax, {
    version: '%{version}'
  });

});