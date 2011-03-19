/**
 * The magic list of LeftJS
 *
 * The goal in here is to provide a quick, steady and inheritable
 * JavaScript 1.7 Array like interface with some additional
 * features, so that we could iterate through anything in a civilize
 * maner without tempering with the JavaScript core.
 *
 * NOTE: this unit _does not_ provide access to the individual
 *       elements via the `[index]` calls and it also doesn't
 *       clone the original iterable object!
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
function List(items) {
  this._ = items;
}

ext(List.prototype, {
  _: undefined,

  /**
   * The standard `forEaech` equivalent
   *
   * @param {mixed} method name or a callback function
   * @param {mixed} scope object or the method param
   * @return {List} this
   */
  each: function() {
    List_call(Array_forEach, this, arguments);
    return this;
  },

  /**
   * Maps the result of the callback function work into
   * a new {List} object
   *
   * @param {mixed} method name or a callback function
   * @param {mixed} scope object or the method param
   * @return {List} new
   */
  map: function() {
    return new List(List_call(Array_map, this, arguments));
  },

  /**
   * Creates a new list that has only matching items in it
   *
   * @param {mixed} method name or a callback function
   * @param {mixed} scope object or the method param
   * @return {List} new
   */
  filter: function() {
    return new List(List_call(Array_filter, this, arguments));
  },

  /**
   * Creates a new list that has no matching items in it
   *
   * @param {mixed} method name or a callback function
   * @param {mixed} scope object or the method param
   * @return {List} new
   */
  reject: function() {
    return new List(List_call(Array_reject, this, arguments));
  },

  /**
   * Creates a new list without the specified items
   *
   * @param {mixed} item
   * .....
   * @return {List} new
   */
  without: function() {
    var filter = A(arguments);
    return this.reject(function(item) {
      return filter.indexOf(item) !== -1;
    });
  },

  /**
   * Creates a new list that doesn't have 'null' and 'undefined' values
   *
   * @return {List} new
   */
  compact: function() {
    return this.without(null, undefined);
  },

  /**
   * Converts the list into an instance or {Array}
   *
   * @return {Array} new
   */
  toArray: function() {
    return A(this._);
  },

  /**
   * Clones the list with all the internal data
   *
   * @return {List} new
   */
  clone: function() {
    return new List(A(this._));
  },

  /**
   * Debugability improover
   *
   * @return {String} representation
   */
  toString: function() {
    return '#<List ['+ this._ +']>';
  }
});

// private
var

Array_proto   = [],
Array_forEach = Array_proto.forEach,
Array_map     = Array_proto.map,
Array_filter  = Array_proto.filter;

function Array_reject(callback, scope) {
  return Array_filter.call(this, function() {
    return !callback.apply(scope, arguments);
  });
}


// calls the array method on the list with the arguments
function List_call(method, list, args) {
  return method.apply(list._, args);
}