/**
 * Utility functions for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var
Object_toString = Object.prototype.toString,
Array_slice     = Array.prototype.slice;

/**
 * Converts iterables into arrays
 *
 * @param {mixed} iterable
 * @return {Array} array
 */
function A(it) {
  return Array_slice.call(it, 0);
}

/**
 * Extends one object with another
 *
 * @param {Object} extendee
 * @param {Object} extender (null and undefined is acceptable)
 * @return {Object} extendee
 */
function ext(one, another) {
  if (another == null) {
    another = {};
  }

  for (var key in another) {
    one[key] = another[key];
  }

  return one;
}

/**
 * Checks if the given value is a string
 *
 * @param {mixed} something
 * @return {boolean} check result
 */
function isString(value) {
  return typeof(value) === 'string';
}

/**
 * Checks if the given value is a number
 *
 * @param {mixed} something
 * @return {boolean} check result
 */
function isNumber(value) {
  return typeof(value) === 'number';
}

/**
 * Checks if the given value is a function
 *
 * @param {mixed} some value
 * @return {boolean} check result
 */
function isFunction(value) {
  return typeof(value) === 'function';
}

/**
 * Checks if the given value is an array
 *
 * @param {mixed} some value
 * @return {boolean} check result
 */
function isArray(value) {
  return Object_toString.call(value) === '[object Array]';
}

/**
 * Checks if the given value is a plain object
 *
 * @param {mixed} some value
 * @return {boolean} check result
 */
function isObject(value) {
  return Object_toString.call(value) === '[object Object]';
}

