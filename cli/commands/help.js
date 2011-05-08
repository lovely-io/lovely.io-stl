/**
 * The help manuals command
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

function commands_list() {
  return require('fs').readdirSync(__dirname).map(function(file) {
    return file.replace(/\.js$/, '');
  });
}


exports.init = function(args) {
  if (args[0]) {
    if (commands_list().indexOf(args[0]) > -1) {
      require('./'+ args[0]).help(args.slice(1));
    } else {
      console.log("Unknown command '" + args[0] + "'");
    }
  } else {
    console.log(
      "Usage: lovely <command>\n\n" +
      "Where <command> is one of:\n" +
      "    " + commands_list().join(', ') + "\n\n"+
      "Help usage: lovely help <command> \n\n"
    );
  }
}