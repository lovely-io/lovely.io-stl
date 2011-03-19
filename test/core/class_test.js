/**
 * The `Class` unit tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

describe('Class', {

  "new Class({..})": {
    topic: function() {
      return new LeftJS.Class({
        getName: function() {
          return this.name;
        },

        setName: function(name) {
          this.name = name;
        }
      });
    },

    'should be typeof a Function': function(Klass) {
      assert.isFunction(Klass);
    },

    'should have those methods in its prototype': function(Klass) {
      assert.isFunction(Klass.prototype.getName);
      assert.isFunction(Klass.prototype.setName);
    },

    'should not have anything besides those names': function(Klass) {
      var keys = [], key;

      for (key in Klass.prototype) {
        keys.push(key);
      }

      assert.deepEqual(keys, ['getName', 'setName']);
    },

    'should allow to make instances of it': function(Klass) {
      var klass = new Klass();

      assert.instanceOf(klass, Klass);
    },

    'should have those methods working': function(Klass) {
      var klass = new Klass();

      klass.setName('boo-hoo');

      assert.equal('boo-hoo', klass.getName());
    }
  },

  'new Class({initialize: ...})': {
    topic: function() {
      return new LeftJS.Class({
        initialize: function(a, b) {
          this.name = a + '-' + b;
        }
      });
    },

    'should call the constructor on the instance': function(Klass) {
      var klass = new Klass('boo', 'hoo');

      assert.equal('boo-hoo', klass.name);
    },

    "should return the constructor's result if sent": function() {
      var Klass = new LeftJS.Class({
        initialize: function() {
          return ['some-other-data'];
        }
      });

      assert.deepEqual(new Klass(), ['some-other-data']);
    }
  },

  'new Class': {
    topic: function() {
      return this.ParentKlass = new LeftJS.Class({
        method: function() {
          return 'parent';
        }
      });
    },

    '(Parent)': {
      topic: function(Parent) {
        return new LeftJS.Class(Parent);
      },

      "should refer '.parent' to the parent class": function(Klass) {
        assert.same(Klass.parent, this.ParentKlass);
      },

      "should keep the parent's 'method'": function(Klass) {
        assert.same(Klass.prototype.method, this.ParentKlass.prototype.method);
      }
    },

    '(Parent, {...})': {
      topic: function(Parent) {
        return new LeftJS.Class(Parent, {
          method: function() {
            return 'child';
          }
        });
      },

      "should refer '.parent' to the parent class": function(Klass) {
        assert.same(Klass.parent, this.ParentKlass);
      },

      "should replace the parent class method": function(Klass) {
        assert.notEqual(Klass.prototype.method, this.ParentKlass.prototype.method);
      },

      "should inherit the parent's class type": function(Klass) {
        var klass = new Klass();

        assert.instanceOf(klass, Klass);
        assert.instanceOf(klass, this.ParentKlass);
      },

      "should call this class methods": function(Klass) {
        var klass = new Klass();

        assert.equal(klass.method(), 'child');
      }
    }
  }

}, module);
