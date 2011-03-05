/**
 * Utility function tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var

vows   = require('vows'),
assert = require('assert'),

LeftJS = require('../left').LeftJS;

vows.describe('Core utils').addBatch({
  "'ext(a,b)'": {
    topic: function() { return LeftJS.ext; },

    'should extend one object with another': function(ext) {
      var a = {a: 1}, b = {b: 2}, c = ext(a, b);
      assert.deepEqual({a:1, b:2}, c);
      assert.equal(a, c);
    },

    "should accept 'null' as the second argument": function(ext) {
      assert.deepEqual({a: 1}, ext({a: 1}, null));
    },

    "should accept 'undefined' as the second argument": function(ext) {
      assert.deepEqual({a: 1}, ext({a: 1}, undefined));
    }
  }

}).export(module);