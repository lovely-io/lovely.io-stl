/**
 * Package, local building command
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
exports.init = function(args) {
  var fs       = require('fs');
  var path     = require('path');
  var source   = require('../source');
  var location = process.cwd();
  var package  = require('../package').parse(location + "/package.json");

  location +=  "/build/";
  path.existsSync(location) || fs.mkdirSync(location, 0755);

  location += package.name;
  fs.writeFileSync(location + "-src.js", source.compile());
  fs.writeFileSync(location + ".js",     source.minify());

  system('gzip -c '+ location +'.js > '+ location +'.js.gz');

  console.log("» Compiling: "+ package.name + " Done".green);
};

exports.help = function(args) {
  console.log(
    "Builds and minifies the source code in a single file\n\n" +
    "Usage:\n    lovely build"
  );
};