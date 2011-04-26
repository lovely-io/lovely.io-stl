/**
 * The {List} unit tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

var List  = LeftJS.List;
var array = [1,2,3,4,5];
var list  = new List(array);

var A     = LeftJS.A;

function ensure_new_list(object) {
  assert.instanceOf (object, List);
  assert.notSame    (object, list);
}

assert.listEqual = function(list, array) {
  assert.instanceOf (list, List);
  assert.deepEqual  (A(list), A(array));
}

// just a dummy class to test calls-by-name
var Foo = new LeftJS.Class({
  value: null,

  initialize: function(v) {
    this.value = v;
  },

  getValue: function() {
    return this.value;
  },

  addValue: function(v) {
    return this.value += v;
  },

  even: function() {
    return this.value % 2 === 0;
  }
});

// making a list of Foo stuff to test various things
var FooList = new LeftJS.Class(List, {
  initialize: function() {
    this.$super([
      new Foo(1),
      new Foo(2),
      new Foo(3),
      new Foo(4)
    ]);
  }
});


describe("List", {
  'constructor': {
    topic: list,

    'should copy the array into itself': function(list) {
      assert.listEqual(list, array);
    },

    "should make an instance of 'List'": function(list) {
      assert.instanceOf(list, List);
    },

    "should inherit the Array": function(list) {
      assert.instanceOf(list, Array);
    }
  },

  '#first': {
    '\b()': {
      topic: list.first(),

      'should return the first item on the list': function(item) {
        assert.same(item, list[0]);
      }
    },

    '\b(callback)': {
      topic: function() {
        return list.first(function(item) { return item % 2 == 0; });
      },

      'should return the first item that match the callback': function(item) {
        assert.same(item, 2);
      }
    }
  },

  '#last': {
    '\b()': {
      topic: list.last(),

      'should return the last item on the list': function(item) {
        assert.same(item, list[list.length - 1]);
      }
    },

    '\b(callback)': {
      topic: function() {
        return list.last(function(item) { return item % 2 == 0; });
      },

      'should return the last matching item': function(item) {
        assert.same(item, 4);
      }
    }
  },

  '#size()': {
    topic: list.size(),

    'should return the list size': function(size) {
      assert.same(size, list.length);
    }
  },

  '#each(callback)': {
    topic: function() {
      this.items   = [];
      this.indexes = [];

      return list.each(function(item, index) {
        this.items.push(item);
        this.indexes.push(index);
      }, this);
    },

    'should get through all the items on the list': function(items) {
      assert.deepEqual (this.items, [1,2,3,4,5]);
    },

    'should send the index into the callback': function(items) {
      assert.deepEqual (this.indexes, [0,1,2,3,4]);
    },

    'should return the list object back': function(result) {
      assert.same (result, list);
    }
  },

  '#each("name", "arg")': {
    topic: new FooList().each("addValue", 2),

    'should add 2 to every value on the list': function(list) {
      assert.instanceOf (list, FooList);
      assert.listEqual  (list.map(function(i) { return i.value; }), [3,4,5,6]);
    }
  },

  '#map(callback)': {
    topic: list.map(function(item) {
      return item * 2;
    }),

    'should make a new list': ensure_new_list,

    'should pack all the mapping results': function(list) {
      assert.listEqual (list, [2,4,6,8,10]);
    }
  },

  '#map("attr_name")': {
    topic: new FooList().map("value"),

    "should map the 'value' properties of the list": function(list) {
      assert.listEqual (list, [1,2,3,4]);
    }
  },

  '#map("method_name")': {
    topic: new FooList().map('getValue'),

    "should map the results of the 'getValue()' calls on the list the list": function(list) {
      assert.listEqual (list, [1,2,3,4]);
    }
  },

  '#map("method_name", "argument")': {
    topic: new FooList().map('addValue', 3),

    "should map the results of the 'addValue(3)' method calls": function(list) {
      assert.listEqual (list, [4,5,6,7]);
    }
  },

  '#map("method_name", "arg1", "arg2")': {
    topic: new List(['boo', 'hoo']).map('replace', 'oo', 'aa'),

    "should map the result of calls": function(list) {
      assert.listEqual (list, ['baa', 'haa']);
    }
  },

  '#filter(callback)': {
    topic: list.filter(function(item) {
      return item % 2;
    }),

    'should create a new List': ensure_new_list,

    'should pack it with filtered data': function(list) {
      assert.listEqual (list, [1,3,5]);
    }
  },

  '#filter("method_name")': {
    topic: new FooList().filter('even'),

    "should filter the list by the method name calls": function(list) {
      assert.listEqual (list.map('value'), [2,4]);
    }
  },

  '#reject(callback)': {
    topic: list.reject(function(item) {
      return item % 2;
    }),

    'should create a new List': ensure_new_list,

    'should filter out all matching elements': function(list) {
      assert.listEqual (list, [2,4]);
    }
  },

  '#reject("method_name")': {
    topic: new FooList().reject("even"),

    "should reject values based on the name call": function(list) {
      assert.listEqual (list.map('value'), [1,3]);
    }
  },

  '#without(a,b,c)': {
    topic: list.without(1,2,4),

    'should create a new List': ensure_new_list,

    'should filter out listed values': function(list) {
      assert.listEqual (list, [3,5]);
    }
  },

  '#compact()': {
    topic: function() {
      this.original = new List([null, '', undefined, 0, 1]);
      return this.original.compact();
    },

    'should create a new List': function(list) {
      assert.instanceOf (list, List);
      assert.notSame    (list, this.original);
    },

    'should filter out nulls and undefineds': function(list) {
      assert.listEqual (list, ['', 0, 1]);
    }
  },

  '#toArray()': {
    topic: list.toArray(),

    'should make an array out of the list': function(array) {
      assert.isArray (array);
    },

    'should feed it with the original data': function(array) {
      assert.deepEqual (array, A(list));
    },

    'should make a clone of the list not refer it by a link': function(array) {
      assert.notSame (array, A(list));
    }
  },

  '#clone()': {
    topic: list.clone(),

    'should make a new list': ensure_new_list,

    'should clone the data': function(result) {
      assert.deepEqual (A(result), A(list));
      assert.notSame   (result, list);
    }
  },

  '#indexOf': {
    topic: list.indexOf(2),

    'should return left index for the item': function(index) {
      assert.equal(index, array.indexOf(2));
    }
  },

  '#lastIndexOf': {
    topic: list.lastIndexOf(2),

    'should return the right index for the item': function(index) {
      assert.equal(index, array.lastIndexOf(2));
    }
  },

  '#push': {
    topic: function() {
      var list = new List([1,2,3]);
      list.push(4);
      return list;
    },

    'should push the item into the list': function(list) {
      assert.listEqual (list, [1,2,3,4]);
    }
  },

  '#pop': {
    topic: function() {
      this.list = new List([1,2,3,4]);
      return this.list.pop();
    },

    "should return the last item out of the list": function(item) {
      assert.equal (item, 4);
    },

    "should subtract the list": function() {
      assert.listEqual (this.list, [1,2,3]);
    }
  },

  '#shift': {
    topic: function() {
      this.list = new List([1,2,3,4]);
      return this.list.shift();
    },

    'should return the first item': function(item) {
      assert.equal (item, 1);
    },

    'should subtract the list itself': function() {
      assert.listEqual (this.list, [2,3,4]);
    }
  },

  '#unshift': {
    topic: function() {
      var list = new List([2,3,4]);
      list.unshift(1);
      return list;
    },

    'should unshift the item into the list': function(list) {
      assert.listEqual (list, [1,2,3,4]);
    }
  },

  '#slice': {
    topic: list.slice(2),

    'should make a new list': ensure_new_list,

    'should slice the original list': function(list) {
      assert.listEqual(list, [3,4,5]);
    }
  }
}, module);
