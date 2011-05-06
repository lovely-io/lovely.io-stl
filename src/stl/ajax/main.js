/**
 * The AJAX support module for Lovely
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Lovely(function() {
  var ext   = Lovely.ext,
      Class = Lovely.Class;

  include('src/ajax');
  include('src/jsonp');
  include('src/iframe');

  Lovely.Ajax = Ajax;

  return ext(Ajax, {
    version: '%{version}'
  });

});