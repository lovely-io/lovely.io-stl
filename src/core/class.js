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
    return 'initialize' in this ?
      this.initialize.apply(this, arguments) : this;
  });

  // handling the inheritance
  function Parent() {}
  Parent.prototype = parent.prototype;
  Klass.prototype  = new Parent();
  Klass.parent     = parent;

  // loading shared modules
  ext(Klass, Class)
    .extend.apply( Klass, params.extend  ? ensure_Array(params.extend)  : [])
    .include.apply(Klass, params.include ? ensure_Array(params.include) : []);

  delete(params.extend);
  delete(params.include);

  // loading the main properties
  return Klass.include(params);
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
        parent = this.parent;
        super_method = false;

        while (parent) {
          if (key in parent.prototype) {
            if (isFunction(parent.prototype[key])) {
              super_method = parent.prototype[key];
            }
            break;
          }
          parent = parent.parent;
        }

        this.prototype[key] = super_method ? function(method, super_method) {
          return function() {
            this.$super = super_method;
            return method.apply(this, arguments);
          };
        }(module[key], super_method) : module[key];
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
