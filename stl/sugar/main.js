/**
 * The syntax sugar for the 'dom' module of LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS(['dom', 'lang'], function() {

  include('src/element');
  include('src/string');

  return {
    version: '%{version}'
  };
});