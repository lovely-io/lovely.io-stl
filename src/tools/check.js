/**
 * Kicks in the JSHint check on the sourcecode
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var source = require('./source');
var check  = require('jshint').JSHINT;

exports.init = function() {
  var report;

  check(source.build(), {
    boss:   true,
    curly:  true,
    expr:   true
  });

  if (check.errors.length) {
    report = "\u001B[31m - Source check failed: \u001B[0m\n\n"

    check.errors.forEach(function(error) {
      if (error && error.id === '(error)') {
        for (var j=0, pointer=''; j < error.character-1; j++) { pointer += '-'; }

        report += "   \u001B[35m"+ error.reason +"\u001B[0m ";

        if (error.evidence) {
          report += "Line: "+ error.line + ", Char: "+ error.character + "\n";
          report += "   "+ error.evidence + "\n";
          report += "   \u001B[33m"+ pointer + "^\u001B[0m";
        }

        report += "\n\n";
      }
    });

  } else {
    report = "\u001B[32m - Successfully passed\u001B[0m";
  }

  console.log(report);
};