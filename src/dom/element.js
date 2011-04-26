/**
 * Defines the basic dom-element wrapper
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var Element = new Class(Wrapper, {

  initialize: function(element, options) {
    if (typeof(element) === 'string') {
      element = document.createElement(element);
      options == null && (options = {});
      for (var key in options) {
        element[key] = options[key];
      }
    }

    this.$super(element);
  }

});