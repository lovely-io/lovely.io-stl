/**
 * The console commands front interface.
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('./config');

/**
 * A shortcut to make the system calls
 *
 * @param {String} unix command
 * @param {Function} optional callback
 * @return {undefined}
 */
global.system   = function(cmd, callback) {
  require('child_process').exec(cmd,
    function(error, stdout) {
      if (error) throw error;
      callback && callback();
    }
  );
};

/**
 * Makes a string of certain size by adding spaces at the end
 *
 * @param {Number} desired length
 * @return {String} of that length
 */
String.prototype.ljust = function(length) {
  var str = this;

  while (str.length < length) {
    str += ' ';
  }

  return str;
};

/**
 * Colors and styles hackity hack
 */
var styles = {
  white:   [37, 39],
  grey:    [90, 39],
  black:   [90, 39],
  blue:    [34, 39],
  cyan:    [36, 39],
  green:   [32, 39],
  magenta: [35, 39],
  red:     [31, 39],
  yellow:  [33, 39]
}, key;

for (key in styles) {
  (function(key, start, end) {
    String.prototype.__defineGetter__(key, function() {
      return '\u001B['+ start +'m'+ this +
             '\u001B['+ end   +'m';
    });
  })(key, styles[key][0], styles[key][1]);
}


exports.init = function(args) {
  args[0] || (args[0] = 'help');

  var path    = require('path');
  var command = __dirname + '/commands/'+ args[0];

  if (path.existsSync(command + ".js")) {
    require(command).init(args.slice(1));
  } else {
    console.log("Unknown command '" + args[0] + "'");
  }
};