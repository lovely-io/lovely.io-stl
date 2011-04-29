/**
 * Utility function tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

describe('Core Utils', {
  "ext(a,b)": {
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
  },

  "bind": {
    topic: function() {
      var result = this.result = {};

      return function() {
        result.context = this;
        result.args    = LeftJS.A(arguments);
      }
    },

    '\r(context)': {
      topic: function(original) {
        return LeftJS.bind(original, this.context = {});
      },

      "should execute the original in the prebinded context": function(callback) {
        callback();

        assert.same (this.result.context, this.context);
        assert.deepEqual (this.result.args, []);
      },

      "should execute the original even when called in a different context": function(callback) {
        callback.apply({other: 'context'});

        assert.same (this.result.context, this.context);
        assert.deepEqual (this.result.args, []);
      },

      "should bypass the arguments to the original function": function(callback) {
        callback(1,2,3);

        assert.same (this.result.context, this.context);
        assert.deepEqual (this.result.args, [1,2,3]);
      }
    },

    '\r(context, arg1, arg2,..)': {
      topic: function(original) {
        return LeftJS.bind(original, this.context = {}, 1,2,3);
      },

      "should pass the prebinded arguments into the original function": function(callback) {
        callback();

        assert.same (this.result.context, this.context);
        assert.deepEqual (this.result.args, [1,2,3]);
      },

      "should handle additional arguments if specified": function(callback) {
        callback(4,5,6);

        assert.same (this.result.context, this.context);
        assert.deepEqual (this.result.args, [1,2,3,4,5,6]);
      }
    }
  },

  'trim(string)': {
    topic: LeftJS.trim("  boo hoo!\n\t "),

    "should trim the excessive spaces out": function(string) {
      assert.equal (string, "boo hoo!");
    }
  },

  "isString(value)": assertTypeCheck('isString', {
    ok:   [''],
    fail: [1, 2.2, null, undefined, true, false, {}, function() {}]
  }),

  "isNumber(value)": assertTypeCheck('isNumber', {
    ok:   [1, 2.2],
    fail: ['11', '2.2', true, false, null, undefined, [], {}, function() {}]
  }),

  "isFunction(value)": assertTypeCheck('isFunction', {
    ok:   [function() {}, new Function('return 1')],
    fail: ['', 1, 2.2, true, false, null, undefined, [], {}]
  }),

  "isArray(value)": assertTypeCheck('isArray', {
    ok:   [[]],
    fail: ['', 1, 2.2, true, false, null, undefined, {}, function() {}]
  }),

  "isObject(value)": assertTypeCheck('isObject', {
    ok:   [{}],
    fail: ['', 1, 2.2, true, false, null, undefined, [], function() {}]
  }),

  "A(iterable)": {
    topic: function() { return LeftJS.A; },

    "should convert arguments into arrays": function(A) {
      var array = A((function() { return arguments; })(1, 2, 3));

      assert.isArray   (array);
      assert.deepEqual ([1,2,3], array);
    }
  },

  "L(iterable)": {
    topic: function() { return LeftJS.L },

    "should make a List": function(L) {
      var l = L([1,2,3]);

      assert.instanceOf (l, LeftJS.List);
      assert.deepEqual  (l.toArray(), [1,2,3]);
    }
  },

  "H(object)": {
    topic: function() { return LeftJS.H },

    "should make a Hash": function(H) {
      var hash = H({a:1});

      assert.instanceOf (hash, LeftJS.Hash);
      assert.deepEqual  (hash.toObject(), {a:1});
    }
  }

}, module);

/**
 * A shortcut for the type check functions testing
 *
 * @param {String} function name
 * @param {Object} okays and fails
 * @return void
 */
function assertTypeCheck(name, options) {
  var def = {
    topic: function() { return LeftJS[name]; }
  };

  for (var i=0; i < options.ok.length; i++) {
    (function(value) {
      def["should return 'true' for: "+ util.inspect(value)] = function(method) {
        assert.isTrue(method(value));
      }
    })(options.ok[i]);
  }

  for (var i=0; i < options.fail.length; i++) {
    (function(value) {
      def["should return 'false' for: "+ util.inspect(value)] = function(method) {
        assert.isFalse(method(value));
      }
    })(options.fail[i]);
  }

  return def;
}
