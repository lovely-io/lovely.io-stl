/**
 * The syntax sugar for the 'dom' module of Lovely IO
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Lovely(['dom', 'lang'], function() {

  include('src/element');
  include('src/string');

  return {
    version: '%{version}'
  };
});