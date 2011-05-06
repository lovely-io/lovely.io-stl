/**
 * The DOM management module for Lovely IO
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Lovely(function() {
  var ext   = Lovely.ext,
      Class = Lovely.Class;

  include('src/browser');
  include('src/wrapper');
  include('src/document');
  include('src/element');
  include('src/window');
  include('src/event');
  include('src/search');

  /**
   * The main function of the DOM API, it can take several types of arguments
   *
   * Search:
   *   $('some#css.rule'[, optionally a context]) -> Lovely.Search
   *
   * Creation:
   *   $('<div>bla bla bla</div>') -> Lovely.Search
   *
   * DOM-Ready:
   *   $(function() { // dom-ready content // }); -> Lovely.Document
   *
   * DOM-Wrapper:
   *   $(element)  -> Lovely.Element
   *   $(document) -> Lovely.Document
   *   $(window)   -> Lovely.Window
   *   ...
   *
   * @param {String|Function|Element|Document} stuff
   * @return {Lovely.Search|Lovely.Wrapper} result
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
  ext(Lovely, {
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
  Browser.OLD && Lovely(['old']);

  // returning the module
  return ext($, {
    version: '%{version}'
  });
});