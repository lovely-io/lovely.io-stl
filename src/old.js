/**
 * Old browsers support patches for the 'dom' package
 *
 * ATTENTION! this module is loaded automatically by the
 * 'dom' package when it's needed
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('old', ['dom'], function() {

  require('old/util');
  require('old/list');
  require('old/search');

  return {
    version: '%{version}'
  };
});