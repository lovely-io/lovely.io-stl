/**
 * The DOM management module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS('dom', function() {
  var ext   = LeftJS.ext,
      Class = LeftJS.Class;

  require('src/browser');
  require('src/wrapper');
  require('src/document');
  require('src/element');
  require('src/window');
  require('src/event');
  require('src/search');

  /**
   * The main function of the DOM API, it can take several types of arguments
   *
   * Search:
   *   $('some#css.rule'[, optionally a context]) -> LeftJS.Search
   *
   * Creation:
   *   $('<div>bla bla bla</div>') -> LeftJS.Search
   *
   * DOM-Ready:
   *   $(function() { // dom-ready content // }); -> LeftJS.Document
   *
   * DOM-Wrapper:
   *   $(element)  -> LeftJS.Element
   *   $(document) -> LeftJS.Document
   *   $(window)   -> LeftJS.Window
   *   ...
   *
   * @param {String|Function|Element|Document} stuff
   * @return {LeftJS.Search|LeftJS.Wrapper} result
   */
  function $(value, context) {
    switch (typeof(value)) {
      case 'string':   return new Search(value, context);
      case 'function': return $(document).on('ready', value);
      case 'object':   return wrap(value);
      default:         return value;
    }
  }

  // exporting the main classes
  ext(LeftJS, {
    $:        $,
    Browser:  Browser,
    Wrapper:  Wrapper,
    Document: Document,
    Element:  Element,
    Window:   Window,
    Event:    Event,
    Search:   Search
  });

  // loading up the 'old' module to support the old browsers
  Browser.OLD && LeftJS(['old']);

  // returning the module
  return ext($, {
    version: '%{version}'
  });
});