/**
 * Hash is a little inheritable wrapper over Object
 * to handle key-value things
 *
 * NOTE: Hash filters all the lists like keys/values
 *       and so one by the `hasOwnProperty` check
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
function Hash(object) {
  this._ = object;
}

ext(Hash.prototype, {
  _: undefined,

  /**
   * Returns the list of keys in the object
   *
   * @return Array of keys
   */
  keys: function() {
    var key, object = this._, result = [];

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        result.push(key);
      }
    }

    return result;
  },

  /**
   * Returns a list of values for the object
   *
   * @return Array of keys
   */
  values: function() {
    var key, object = this._, result = [];

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        result.push(object[key]);
      }
    }

    return result;
  },

  /**
   * Chesks if the object is empty
   *
   * @return {boolean} check result
   */
  empty: function() {
    var key, object = this._;

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        return false;
      }
    }

    return true;
  },

  /**
   * Loops through every key-value pair in the list
   *
   * @param {Function} callback
   * @param {Object} optional scope
   * @return {Hash} this
   */
  each: function(callback, scope) {
    var key, object = this._;

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        callback.call(scope, key, object[key], this);
      }
    }

    return this;
  },

  /**
   * Creates a complete clone of the the Hash
   *
   * @return {Hash} clone
   */
  clone: function() {
    return this.merge();
  },

  /**
   * Maps results of calls on the callback function
   * with every key-value pairs in the hash
   *
   * @param {Function} callback
   * @param {Object} optional scope
   * @return {Array} result of calls
   */
  map: function(callback, scope) {
    var key, object = this._, result = [];

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        result.push(callback.call(scope, key, object[key], this));
      }
    }

    return result;
  },

  /**
   * Creates a new hash by filtering out the original one
   *
   * @param {Function} callback
   * @param {Object} optional scope
   * @return {Hash} new
   */
  filter: function(callback, scope) {
    var key, object = this._, data = {};

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        if (callback.call(scope, key, object[key], this)) {
          data[key] = object[key];
        }
      }
    }

    return new Hash(data);
  },

  /**
   * Creates a new hash by rejecting some values out the original one
   *
   * @param {Function} callback
   * @param {Object} optional scope
   * @return {Hash} new
   */
  reject: function(callback, scope) {
    var key, object = this._, data = {};

    for (key in object) {
      if (object.hasOwnProperty(key)) {
        if (!callback.call(scope, key, object[key], this)) {
          data[key] = object[key];
        }
      }
    }

    return new Hash(data);
  },

  /**
   * Creates a new Hash by merging the content of the current
   * hash with all the incomming ones
   *
   * @param {Object} or {Hash} to merge
   * ....
   * @return {Hash} new
   */
  merge: function() {
    var list = A(arguments), key, object = this._, data = {};

    while (object !== undefined) {
      if (object instanceof Hash) {
        object = object._;
      }

      for (key in object) {
        if (object.hasOwnProperty(key)) {
          data[key] = object[key];
        }
      }

      object = list.shift();
    }

    return new Hash(data);
  }
});