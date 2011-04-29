/**
 * The JavaScript language compatibility fixes
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

describe('Lang', {
  'String#trim': {
    topic: "  boo hoo!\n\t ".trim(),

    "should trim the excessive spaces out": function(string) {
      assert.equal (string, "boo hoo!");
    }
  },

  'Function#bind': {
    topic: function() {
      var result = this.result = {};

      return function() {
        result.context = this;
        result.args    = LeftJS.A(arguments);
      }
    },

    '\r(context)': {
      topic: function(original) {
        return original.bind(this.context = {});
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
        return original.bind(this.context = {}, 1,2,3);
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
  }
}, module);