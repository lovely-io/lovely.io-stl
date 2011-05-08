/**
 * The `Class` unit tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

var Class = Lovely.Class;

describe('Class', {

  "new Class({..})": {
    topic: function() {
      return new Class({
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

      assert.deepEqual(keys, ['getName', 'setName', 'initialize']);
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
      return new Class({
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
      var Klass = new Class({
        initialize: function() {
          return ['some-other-data'];
        }
      });

      assert.deepEqual(new Klass(), ['some-other-data']);
    }
  },

  'new Class': {
    topic: function() {
      return this.ParentKlass = new Class({
        method: function(data) {
          return data || 'parent';
        }
      });
    },

    '(Parent)': {
      topic: function(Parent) {
        return new Class(Parent);
      },

      "should refer '.__super__' to the parent class": function(Klass) {
        assert.same(Klass.__super__, this.ParentKlass);
      },

      "should keep the parent's 'method'": function(Klass) {
        assert.same(Klass.prototype.method, this.ParentKlass.prototype.method);
      }
    },

    '(Parent, {...})': {
      topic: function(Parent) {
        return new Class(Parent, {
          method: function() {
            return 'child';
          }
        });
      },

      "should refer '.__super__' to the parent class": function(Klass) {
        assert.same(Klass.__super__, this.ParentKlass);
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
    },

    '(Parent, {...}) and $super calls': {
      topic: function(Parent) {
        return new Class(Parent, {
          method: function() {
            return this.$super('parent-data + ') + 'child-data';
          }
        });
      },

      "should preform a proper super-call": function(Klass) {
        assert.equal(
          new Klass().method(),
          'parent-data + child-data'
        );
      }
    }
  },

  'new Class() with shared modules': {
    topic: function() {
      this.ext = {a:function() {}, b:function() {}};
      this.inc = {c:function() {}, d:function() {}};

      return new Class({
        include: this.inc,
        extend:  this.ext
      });
    },

    "should extend the class-level with the 'extend' module": function(Klass) {
      assert.same (Klass.a, this.ext.a);
      assert.same (Klass.b, this.ext.b);

      assert.isFalse ('c' in Klass);
      assert.isFalse ('d' in Klass);
    },

    "should extend the prototype with the 'include' module": function(Klass) {
      assert.same (Klass.prototype.c, this.inc.c);
      assert.same (Klass.prototype.d, this.inc.d);

      assert.isFalse ('a' in Klass.prototype);
      assert.isFalse ('b' in Klass.prototype);
    }
  }

}, module);
