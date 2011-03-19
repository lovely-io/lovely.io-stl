/**
 * The {List} unit tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

var List = LeftJS.List;

describe("List", {
  'constructor': {
    topic: function() {
      return new List(this.array = [1,2,3,4,5]);
    },

    'should link the original iterable by a reference': function(list) {
      assert.same (list._, this.array);
    }
  },

  '#each(callback)': {
    topic: function() {
      var items   = this.items   = [];
      var indexes = this.indexes = [];

      this.list = new List([1,2,3,4,5]);

      return this.list.each(function(item, index) {
        items.push(item);
        indexes.push(index);
      });
    },

    'should get through all the items on the list': function(items) {
      assert.deepEqual (this.items, [1,2,3,4,5]);
    },

    'should send the index into the callback': function(items) {
      assert.deepEqual (this.indexes, [0,1,2,3,4]);
    },

    'should return the list object back': function(list) {
      assert.same (list, this.list);
    }
  },

  '#map(callback)': {
    topic: function() {
      this.original = new List([1,2,3,4,5]);

      return this.original.map(function(item) {
        return item * 2;
      })
    },

    'should make a new list': ensure_new_list,

    'should pack all the mapping results': function(result) {
      assert.deepEqual      (result._, [2,4,6,8,10]);
    }
  },

  '#filter(callback)': {
    topic: function() {
      this.original = new List([1,2,3,4,5]);

      return this.original.filter(function(item) {
        return item % 2;
      })
    },

    'should create a new List': ensure_new_list,

    'should pack it with filtered data': function(result) {
      assert.deepEqual      (result._, [1,3,5]);
    }
  },

  '#reject(callback)': {
    topic: function() {
      this.original = new List([1,2,3,4,5]);

      return this.original.reject(function(item) {
        return item % 2;
      });
    },

    'should create a new List': ensure_new_list,

    'should filter out all matching elements': function(list) {
      assert.deepEqual (list._, [2,4]);
    }
  },

  '#without(a,b,c)': {
    topic: function() {
      this.original = new List([1,2,3,4,5]);

      return this.original.without(1,2,4);
    },

    'should create a new List': ensure_new_list,

    'should filter out listed values': function(list) {
      assert.deepEqual (list._, [3,5]);
    }
  },

  '#compact()': {
    topic: function() {
      this.original = new List([null, '', undefined, 0, 1]);
      return this.original.compact();
    },

    'should create a new List': ensure_new_list,

    'should filter out nulls and undefineds': function(list) {
      assert.deepEqual (list._, ['', 0, 1]);
    }
  },

  '#toArray()': {
    topic: function() {
      this.list = new List([1,2,3,4,5]);
      return this.list.toArray();
    },

    'should make an array out of the list': function(array) {
      assert.isArray (array);
    },

    'should feed it with the original data': function(array) {
      assert.deepEqual (array, this.list._);
    },

    'should make a clone of the list not refer it by a link': function(array) {
      assert.notSame (array, this.list._);
    }
  },

  '#clone()': {
    topic: function() {
      this.original = new List([1,2,3,4,5]);
      return this.original.clone();
    },

    'should make a new list': ensure_new_list,

    'should clone the data': function(list) {
      assert.deepEqual (list._, this.original._);
      assert.notSame   (list._, this.original._);
    }
  }
}, module);

/**
 * Shortcut to ensure that a new list was created
 *
 * @param {List} list
 * @return void
 */
function ensure_new_list(list) {
  assert.instanceOf (list, List);
  assert.notSame    (list, this.original);
}