/**
 * Packages installing command
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

exports.init = function(args) {
  var fs       = require('fs');
  var path     = require('path');
  var dir      = process.cwd();
  var location = lovelyrc.base;
  var source   = require('../source');
  var package  = require('../package').parse(dir + "/package.json");

  if (!package.valid) return package.dump();

  location[location.length - 1] == '/' || (location += '/');
  location += package.name + '/' + package.version;

  system('rm -rf '+ location, function() {
    system('mkdir -p '+ location, function() {
      system('cd '+ dir + '; ../../bin/lovely build', function() {
        system('cp -r '+ dir + '/* '+ location);
      });
    });
  });
};


exports.help = function(args) {
  console.log(
    "Install a lovely package\n\n" +
    "Usage: \n    lovely install <package-name>\n\n" +

    "To install your own package locally, run:\n" +
    "    lovely install\n" +
    "from your project root directory"
  );
};