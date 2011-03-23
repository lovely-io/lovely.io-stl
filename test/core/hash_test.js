/**
 * The `Hash` unit tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

var Hash = LeftJS.Hash;

/**
 * A dummy class to check the prototype
 * values filtration
 *
 * @param {Object} own properties
 * @return undefined
 */
function Foo(object) {
  object || (object = {});
  for (var key in object) {
    this[key] = object[key];
  }
}
Foo.prototype.boo = 'boo';
Foo.prototype.hoo = 'hoo';


describe('Hash', {
  'initialization': {
    topic: function() {
      this.object = {};
      return new Hash(this.object);
    },

    "should create an instance of Hash": function(hash) {
      assert.instanceOf (hash, Hash);
    },

    "should refer to the original object via the '_' attribute": function(hash) {
      assert.same (hash._, this.object);
    }
  },

  '#keys()': {
    "should return an array of the keys": function(keys) {
      assert.deepEqual(['a', 'b'], new Hash({a: 1, b: 2}).keys());
    },

    "should skip prototype keys": function(hash) {
      assert.deepEqual(['a', 'b'], new Hash(new Foo({a: 1, b: 2})).keys());
    }
  },

  '#values()': {
    "should return an array of values": function(values) {
      assert.deepEqual([1, 2], new Hash({a: 1, b: 2}).values());
    },

    "should skip any prototype values": function(values) {
      assert.deepEqual([1, 2], new Hash(new Foo({a: 1, b: 2})).values());
    }
  },

  '#empty()': {
    "should say 'true' for empty hashes": function() {
      assert.isTrue (new Hash({}).empty());
    },

    "should say 'false' for non empty hashes": function() {
      assert.isFalse (new Hash({a: 1}).empty());
    },

    "should filter out prototype properties": function() {
      assert.isTrue  (new Hash(new Foo()).empty());
      assert.isFalse (new Hash(new Foo({a: 1})).empty());
    }
  },

  '#clone()': {
    topic: function() {
      return {a:1, b:2};
    },

    "should create a new Hash with cloned data": function(data) {
      var original = new Hash(data), clone = original.clone();

      assert.instanceOf (clone, Hash);
      assert.notSame    (clone, original);

      assert.deepEqual  (clone._, data);
      assert.notSame    (clone._, data);
    },

    "should skip any prototype data": function(data) {
      var original = new Hash(new Foo(data)), clone = original.clone();

      assert.instanceOf (clone, Hash);
      assert.notSame    (clone, original);

      assert.deepEqual  (clone._, data);
      assert.notSame    (clone._, data);
    }
  },

  '#each(callback)': {
    "should go through every key-value pair": function(result) {
      var hash = new Hash({a:1, b:2}), result = [],

      ret = hash.each(function(key, value, hash) {
        result.push([key, value, hash._]);
      });

      assert.same      (ret, hash);
      assert.deepEqual (result, [
        ['a', 1, {a:1, b:2}],
        ['b', 2, {a:1, b:2}]
      ]);
    },

    "should skip the prototype keys and values": function() {
      var result = [];

      new Hash(new Foo({a:1, b:2})).each(function (key, value) {
        result.push([key, value]);
      });

      assert.deepEqual (result, [
        ['a', 1], ['b', 2]
      ]);
    }
  },

  '#map(callback)': {
    "should map result of key-value calls on the callback": function() {
      var hash = {a:1, b:2},

      result = new Hash(hash).map(function (key, value, hash) {
        return [key, value, hash._];
      });

      assert.deepEqual (result, [
        ['a', 1, hash], ['b', 2, hash]
      ]);
    },

    "should skip prototype key-value pairs": function() {
      var result = new Hash(new Foo({a:1, b:2})).map(function(key, value) {
        return [key, value];
      });

      assert.deepEqual (result, [
        ['a', 1], ['b', 2]
      ]);
    }
  },

  '#filter(callback)': {
    topic: function() {
      this.original = new Hash({a:1, b:2, c:3});

      return this.original.filter(function(key, value) {
        return key === 'a' || key === 'c';
      });
    },

    "should create a new Hash object": function(hash) {
      assert.instanceOf (hash, Hash);
      assert.notSame    (hash, this.original);
    },

    "should filter the related object": function(hash) {
      assert.deepEqual (hash._, {a:1, c:3});
    }
  },

  '#reject(callback)': {
    topic: function() {
      this.original = new Hash({a:1, b:2, c:3});

      return this.original.reject(function(key, value) {
        return key === 'a' || key === 'c';
      });
    },

    "should create a new Hash object": function(hash) {
      assert.instanceOf (hash, Hash);
      assert.notSame    (hash, this.original);
    },

    "should filter the related object": function(hash) {
      assert.deepEqual (hash._, {b:2});
    }
  },

  '#merge(o1, o2,..)': {
    topic: function() {
      this.original = new Hash({a:3});
      return this.original.merge(
        {a:1, b:3},
        new Foo({b:2, c:4}), // checking prototypes filtering
        new Hash({c:3})      // checking Hashes processing
      );
    },

    "should create a new Hash object": function(hash) {
      assert.instanceOf (hash, Hash);
      assert.notSame    (hash, this.original);
    },

    "should merge the objects": function(hash) {
      assert.deepEqual (hash._, {a:1, b:2, c:3});
    }
  }
}, module);
