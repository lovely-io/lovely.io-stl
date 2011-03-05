/**
 * Utility functions for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

var ext = LeftJS.ext = function(one, another) {
  if (another == null) {
    another = {};
  }

  for (var key in another) {
    one[key] = another[key];
  }

  return one;
};
