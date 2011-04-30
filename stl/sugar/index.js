/**
 * The syntax sugar for the 'dom' module of LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('sugar', ['dom', 'lang'], function() {

  require('src/element');
  require('src/string');

  return {
    version: '%{version}'
  };
});