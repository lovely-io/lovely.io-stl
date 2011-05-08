/**
 * The `Hash` unit tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

var Hash = Lovely.Hash;

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
  '#initialization': {
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
        result.push([key, value, hash]);
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
        return [key, value, hash];
      });

      assert.deepEqual (result, [
        ['a', 1, hash], ['b', 2, hash]
      ]);
    },

    "should skip prototype key-value pairs": function() {
      var data   = {a: 1, b:2};
      var result = new Hash(new Foo(data)).map(function(key, value, hash) {
        return [key, value, hash];
      });

      assert.deepEqual (result, [
        ['a', 1, data], ['b', 2, data]
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
  },

  '#merge(o1, o2, ..) - deep': {
    topic: function() {
      this.o1 = {a: {b: {c: 'd'}, e: 'f'}};
      this.o2 = {a: {b: {c: 'd', e: 'f'}}};

      return new Hash({}).merge(this.o1, this.o2);
    },

    "should perform a deep merge of the data": function(hash) {
      assert.deepEqual (hash._, {a: {b: {c: 'd', e: 'f'}, e: 'f'}});
    },

    "should delink the keys": function(hash) {
      var o = hash._, o1 = this.o1, o2 = this.o2;

      assert.isTrue(
        o.a !== o1.a && o.a !== o2.a && o.a.b !== o1.a.b && o.a.b !== o2.a.b
      );
    }
  },

  '.keys': {
    "should return keys of an object": function() {
      assert.deepEqual (['a', 'b'], Hash.keys({a:1, b:2}));
    }
  },

  '.values': {
    "should return values of an object": function() {
      assert.deepEqual ([1,2], Hash.values({a: 1, b:2}));
    }
  },

  '.empty': {
    "should check if an object is empty": function() {
      assert.isTrue  (Hash.empty({}));
      assert.isFalse (Hash.empty({a: 1}));
    }
  },

  ".clone": {
    "should clone an object": function() {
      var object = {a: 1};
      var clone  = Hash.clone(object);

      assert.deepEqual (clone, object);
      assert.notSame   (clone, object);
    }
  },

  ".each": {
    topic: function() {
      this.args = [];
      this.obj  = {a: 1, b: 2};
      return Hash.each(this.obj, function(key, value, object) {
        this.args.push([key, value, object]);
      }, this);
    },

    "should run through every key-value pair in the object": function() {
      assert.deepEqual (this.args, [
        ['a', 1, this.obj], ['b', 2, this.obj]
      ]);
    },

    "should return the object itself back": function(result) {
      assert.same (result, this.obj);
    }
  },

  ".map": {
    "should map the results of callbacks on every key-value pairs": function() {
      var result = Hash.map({a: 1, b: 2}, function(key, value) {
        return key + "-" + value;
      });

      assert.deepEqual (result, ["a-1", "b-2"]);
    }
  },

  ".filter": {
    "should create a filtered object": function() {
      var hash = {a: 1, b: 2, c: 3};
      var data = Hash.filter(hash, function(key, value) { return value % 2; });

      assert.notSame   (data, hash);
      assert.deepEqual (data, {a:1, c:3});
    }
  },

  ".reject": {
    "should create a new object without rejected pairs": function() {
      var hash = {a: 1, b: 2, c: 3};
      var data = Hash.reject(hash, function(key, value) { return value % 2; });

      assert.notSame   (data, hash);
      assert.deepEqual (data, {b:2});
    }
  },

  ".merge": {
    "should merge objects and hashes and make a new object": function() {
      var object = {a:1, b:3};
      var result = Hash.merge(
        object,
        new Foo({b:2, c:4}), // checking prototypes filtering
        new Hash({c:3})      // checking Hashes processing
      );

      assert.notSame   (result, object);
      assert.deepEqual (result, {a: 1, b: 2, c: 3});
    }
  }
}, module);
