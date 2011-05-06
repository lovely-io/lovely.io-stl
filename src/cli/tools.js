/**
 * The console tools. Basically it handles
 * all the CLI commands, packaging and so on
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

exports.init = function(args) {
  switch (args[0]) {
    case 'help':
    case undefined:
      console.log(
        "Try:\n\n" +
        "  lovely new projectname\n" +
        "  lovely server\n" +
        "  lovely build\n"  +
        "  lovely check"
      );
      break;

    default:
      require('./tools/'+ args[0]).init(args.slice(1));
  }
};