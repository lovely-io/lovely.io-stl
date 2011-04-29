/**
 * JavaScript 1.7,1.8 methods emulation for browsers
 * that don't support them yet
 *
 * NOTE: this is for the most crucial things only,
 *       leave all the fancy stuff for the 'lang' module
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
Function.prototype.bind || (Function.prototype.bind  = function() {
  var args = A(arguments), context = args.shift(), method = this;

  return function() {
    return method.apply(context, args.concat(A(arguments)));
  };
});

String.prototype.trim || (String.prototype.trim = function() {
  var str = this.replace(/^\s\s*/, ''), i = str.length, re = /\s/;

  while (re.test(str.charAt(--i))) {}

  return str.slice(0, i + 1);
});