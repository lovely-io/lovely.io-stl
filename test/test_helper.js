/**
 * Node.js envinronment initializer for Left.js
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var

fs  = require('fs'),
sys = require('sys'),


// packing and initializing LeftJS
dir = process.cwd() + "/src/",

src = fs.readFileSync(dir + 'left.js').toString();

src = src.replace(/require\(['"](.+?)['"]\);/mg, function(m, filename) {
  return fs.readFileSync(dir + filename + '.js')
    .toString().replace(/($|\n)/g, '$1  ');
});

eval(src);

exports.LeftJS = LeftJS;
exports.Src    = src;


// globalizing those ones so we didn't need to reinit them all the time
global.LeftJS  = LeftJS;
global.util    = require('util');
global.vows    = require('vows');
global.assert  = require('assert');

assert.same    = assert.strictEqual;
assert.notSame = assert.notStrictEqual;

/**
 * A simple shortcut over the Vows to make
 * a single batch descriptions
 *
 * @param {String} name
 * @param {Object} batch hash
 * @param {Object} current module
 * @return void
 */
global.describe = function(thing, batch, module) {
  vows.describe(thing).addBatch(batch).export(module);
}