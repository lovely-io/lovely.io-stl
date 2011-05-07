/**
 * The console commands front interface.
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

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