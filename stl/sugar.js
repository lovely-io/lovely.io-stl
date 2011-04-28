/**
 * The syntax sugar for the 'dom' module of LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('sugar', ['dom', 'lang'], function() {

  require('sugar/element');
  require('sugar/string');

  return {
    version: '%{version}'
  };
});