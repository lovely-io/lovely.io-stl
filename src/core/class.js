/**
 * `Class` is the main classes handler for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
function Class(parent, params) {
  if (!isFunction(parent)) {
    params = parent;
    parent = null;
  }

  function Class() {
    return 'initialize' in this ?
      this.initialize.apply(this, arguments) : this;
  }

  if (parent) {
    var Parent       = function() {};
    Parent.prototype = parent.prototype;
    Class.prototype  = new Parent();
    Class.parent     = parent;
  }

  ext(Class.prototype, params);

  return Class;
}