/**
 * Node.js envinronment initializer for Left.js
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var

fs  = require('fs'),
sys = require('sys'),

dir = process.cwd() + "/src/",

src = fs.readFileSync(dir + 'left.js').toString();

src = src.replace(/require\(['"](.+?)['"]\);/mg, function(m, filename) {
  return fs.readFileSync(dir + filename + '.js')
    .toString().replace(/($|\n)/g, '$1  ');
});

eval(src);

exports.LeftJS = LeftJS;
exports.Src    = src;
