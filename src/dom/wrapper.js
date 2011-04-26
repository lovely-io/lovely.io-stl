/**
 * Defines the common class for all the dom-wrappers
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var Wrapper = new Class({
  _: undefined,

  initialize: function(dom_unit) {
    this._ = dom_unit;
  }
});

Wrapper.Cache = []; // the dom wrappers cache

/**
 * Makes a dom-wrapper for the value
 *
 * @param {mixed} dom-unit
 * @return {Wrapper} dom-unit
 */
function wrap(value) {
  if (value == null) {
    return value;
  } else if (value.nodeType === 1) {
    return new Element(value);
  } else if (value.target || value.srcElement) {
    return new Event(value);
  } else if (value.nodeType === 9) {
    return new Document(value);
  } else if (value.window == window) {
    return new Window(value);
  }
}