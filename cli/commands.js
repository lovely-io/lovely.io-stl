/**
 * The console commands front interface.
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

// parsing the ~/.lovelyrc file
var fs = require('fs');
var options = {};

fs.readFileSync(process.env.HOME + "/.lovelyrc").toString()
  .replace(/(\w+)\s*=\s*([^\n]+)/g, function(m, key, value) {
    options[key] = value;
  });

global.lovelyrc = options;

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