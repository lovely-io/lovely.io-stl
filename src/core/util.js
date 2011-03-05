/**
 * Utility functions for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

var

Object_toString = Object.prototype.toString,


/**
 * Extends one object with another
 *
 * @param {Object} extendee
 * @param {Object} extender (null and undefined is acceptable)
 * @return {Object} extendee
 */
ext = LeftJS.ext = function(one, another) {
  if (another == null) {
    another = {};
  }

  for (var key in another) {
    one[key] = another[key];
  }

  return one;
},


/**
 * Checks if the given value is a string
 *
 * @param {mixed} something
 * @return {boolean} check result
 */
isString = LeftJS.isString = function(value) {
  return typeof(value) === 'string';
},

/**
 * Checks if the given value is a number
 *
 * @param {mixed} something
 * @return {boolean} check result
 */
isNumber = LeftJS.isNumber = function(value) {
  return typeof(value) === 'number';
},

/**
 * Checks if the given value is a function
 *
 * @param {mixed} some value
 * @return {boolean} check result
 */
isFunction = LeftJS.isFunction = function(value) {
  return typeof(value) === 'function';
},

/**
 * Checks if the given value is an array
 *
 * @param {mixed} some value
 * @return {boolean} check result
 */
isArray = LeftJS.isArray = function(value) {
  return Object_toString.call(value) === '[object Array]';
},

/**
 * Checks if the given value is a plain object
 *
 * @param {mixed} some value
 * @return {boolean} check result
 */
isObject = LeftJS.isObject = function(value) {
  return Object_toString.call(value) === '[object Object]';
}