/**
 * Kicks in the JSHint check on the sourcecode
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

/**
 * Runs the JSHint check on the source code
 *
 * @param {Array} arguments
 * @return void
 */
exports.init = function(args) {
  var check  = require('jshint').JSHINT;
  var module = require('../package').parse(process.cwd() + '/package.json').name;
  var report;

  check(require('../source').compile(), {
    boss:   true,
    curly:  true,
    expr:   true
  });

  if (check.errors.length) {
    report = "\u001B[31m - Source check failed for '"+ module +"': \u001B[0m\n\n"

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
    report = " ✓ \u001B[32mOK\u001B[0m '"+ module + "'";
  }

  console.log(report);
};

exports.help = function(args) {
  console.log(
    "Checks the project source code against JSHint\n\n" +
    "Usage: lovely check"
  );
}