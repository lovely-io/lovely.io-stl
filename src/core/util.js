/**
 * Utility functions for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var
Object_toString = Object.prototype.toString,
Array_slice     = Array.prototype.slice,
Function_bind   = Function.prototype.bind || function() {
  var args = A(arguments), context = args.shift(), method = this;
  return function() {
    return method.apply(context, args.concat(A(arguments)));
  };
},
String_trim     = String.prototype.trim || function() {
  var str = this.replace(/^\s\s*/, ''), i = str.length, re = /\s/;
  while (re.test(str.charAt(--i))) {}
  return str.slice(0, i + 1);
};

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
 * Converts iterables into LeftJS.List instances
 *
 * @param {mixed} iterable
 * @return {List} list
 */
function L(it) {
  return new List(it);
}

/**
 * A shortcut to create {Hash} instances
 *
 * @param {Object} object
 * @return {Hash} hash
 */
function H(object) {
  return new Hash(object);
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
 * Binds the function with the context
 *
 * @param {Function} function
 * @param {Object} context
 * @param {mixed} argument
 * .....
 * @return {Function} proxy
 */
function bind() {
  var args = A(arguments);
  return Function_bind.apply(args.shift(), args);
}

/**
 * Trims the exessive spaces from the beginning
 * and the end of the string
 *
 * @param {String} original string
 * @return {String} trimmed string
 */
function trim(string) {
  return String_trim.call(string);
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

// private

/**
 * Checks if the value is an array then returns it,
 * otherways make an one cell array with that value
 *
 * @param {mixed} some value
 * @return {Array} array
 */
function ensure_Array(value) {
  return isArray(value) ? value : [value];
}