/**
 * %{projectunit} main file
 *
 * Copyright (C) %{year} %{username}
 */

// hook up the dependencies
var core    = require('core');
var $       = require('dom');

// local variables assignment
var Class   = core.Class;
var Element = $.Element;

// glue in your files
include('src/%{projectfile}');

// exports your objects in the module
exports.version = '%{version}';

// global exports (don't use unless you're really need that)
global.my_stuff = 'that pollutes the global scope';