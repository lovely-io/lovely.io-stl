/**
 * The JavaScript core extensions module for Lovely
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Lovely(function() {
  var ext = Lovely.ext;

  include('src/array');
  include('src/string');
  include('src/number');
  include('src/function');

  return {
    version: '%{version}'
  };
});