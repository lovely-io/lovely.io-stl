/**
 * Old browsers support patches for the 'dom' package
 *
 * ATTENTION! this module is loaded automatically by the
 * 'dom' package when it's needed
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Lovely(['dom'], function() {

  include('src/util');
  include('src/list');
  include('src/search');

  return {
    version: '%{version}'
  };
});