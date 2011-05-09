#
# Kicks in the JSHint check on the sourcecode
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Runs the JSHint check on the source code
#
# @param {Array} arguments
# @return void
#
exports.init = (args) ->
  check  = require('jshint').JSHINT;
  module = require('../package').parse("#{process.cwd()}/package.json").name;

  check(require('../source').compile(), {
    boss:   true,
    curly:  true,
    expr:   true
  });

  if check.errors.length
    report = "✗ Source check failed in '#{module}' \n\n".red

    for error in check.errors
      if error && error.id == '(error)'
        report += "   "+ error.reason.magenta

        if error.evidence
          report += " Line: #{error.line}, Char: #{error.character}\n"
          report += "   #{error.evidence}\n"
          report += "   #{(''.ljust(error.character-1, '-') + '^').yellow}"

        report += "\n\n"

  else
    report = "✓ " + "OK".green + " » "+ module

  print report;


exports.help = (args) ->
  """
  Checks the project source code against JSHint

  Usage:
      lovely check

  """