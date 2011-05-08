/**
 * CSS search and dom-collections handling interface
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var Search = new Class(Lovely.List, {
  extend: {
    /**
     * Registers pseudo-selectors
     *
     * @param {String} pseudo name
     * @return {Search} self
     */
    addPseudo: function(name, callback) {
      // TODO make my day!
      return this;
    }
  },

  initialize: function(css_rule, context) {
    context == null && (context = document);
    context instanceof Wrapper && (context = context._);

    // TODO handle '<div>boo hoo</div>'
    // TODO handle '#just-an-id'

    this.$super(context.querySelectorAll(css_rule));
    this.each(function(element, i) {
      this[i] = wrap(element);
    });
  }

});

// TODO Copying the methods from the wrapper to the collection
for (var method in Element.prototype) {

}