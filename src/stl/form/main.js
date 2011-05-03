/**
 * The forms handling module for LeftJS
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
LeftJS(['dom'], function($) {
  var ext     = LeftJS.ext,
      Class   = LeftJS.Class,
      Element = LeftJS.Element;

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
  ext(LeftJS, {
    Form:  Form,
    Input: Input
  });

  // exporting the module
  return ext(Form, {
    version: '%{version}'
  });
});