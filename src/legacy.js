/**
 * The old RightJS API support module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('legacy', ['dom', 'form', 'ajax', 'sugar'], function() {

  require('legacy/globals');

  return {
    version: '%{version}'
  };

});