/**
 * `Class` is the main classes handler for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
function Class(parent, params, Klass) {
  if (!isFunction(parent)) {
    params = parent;
    parent = undefined;
  }

  params || (params = {});
  parent || (parent = Class); // <- Class is the default parent!
  Klass  || (Klass  = function Klass() {
    return this.initialize.apply(this, arguments);
  });

  // handling the inheritance
  function Super() {}
  Super.prototype = parent.prototype;
  Klass.prototype = new Super();
  Klass.__super__ = parent;

  // loading shared modules
  ext(Klass, Class)
    .extend.apply( Klass, ensure_Array(params.extend  || []))
    .include.apply(Klass, ensure_Array(params.include || []));

  delete(params.extend);
  delete(params.include);

  // loading the main properties
  Klass.include(params);

  if (!('initialize' in Klass.prototype)) {
    Klass.prototype.initialize = function() {};
  }

  return Klass;
}

/**
 * the class-level utils to manipulate class properties
 *
 * Principles are the same as in Ruby,
 *  * 'extend'  - extends the class level
 *  * 'include' - extends the prototype level
 *
 */
ext(Class, {
  /**
   * Extends the prototype-level attributes
   *
   * @param {Object} module
   * ....
   * @return {Class} this
   */
  include: function() {
    var i=0, key, module, parent, super_method;

    for (; i < arguments.length; i++) {
      module = arguments[i] || {};

      for (key in module) {
        parent = this.__super__;
        super_method = false;

        while (parent) {
          if (key in parent.prototype) {
            if (isFunction(parent.prototype[key])) {
              super_method = parent.prototype[key];
            }
            break;
          }
          parent = parent.__super__;
        }

        this.prototype[key] = Class_make_method(module[key], super_method);
      }
    }

    return this;
  },

  /**
   * Adds a class-level attributes
   *
   * @param {Object} module
   * ...
   * @return {Class} this
   */
  extend: function() {
    for (var i=0; i < arguments.length; i++) {
      ext(this, arguments[i]);
    }

    return this;
  }
});

// rewraps the supermethod when needed
function Class_make_method(method, super_method) {
  return super_method ? function() {
    this.$super = super_method;
    return method.apply(this, arguments);
  } : method;
}