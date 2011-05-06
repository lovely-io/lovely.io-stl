/**
 * The forms handling module for Lovely IO
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Lovely(['dom'], function($) {
  var ext     = Lovely.ext,
      Class   = Lovely.Class,
      Element = Lovely.Element;

  include('src/form');
  include('src/input');

  // setting up the dynamic typecasting for the form-elements
  ext(Element.Wrappers, {
    FORM:     Form,
    INPUT:    Input,
    SELECT:   Input,
    TEXTAREA: Input
  });

  // exporting the globals
  ext(Lovely, {
    Form:  Form,
    Input: Input
  });

  // exporting the module
  return ext(Form, {
    version: '%{version}'
  });
});