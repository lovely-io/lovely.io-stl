/**
 * The initial bootstraping task
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

/**
 * The actual bootstrapping
 *
 * @param {String} optional base_dir
 * @return void
 */
function bootstrap(base_dir) {
  var fs       = require('fs');
  var path     = require('path');
  var home_dir = process.env.HOME;
  var rc_file  = home_dir + '/.lovelyrc';

  base_dir || (base_dir = home_dir + "/.lovely/");

  console.log("Making the base at: ", base_dir);
  if (path.existsSync(base_dir)) {
    console.log(" - Already exists");
  } else {
    fs.mkdirSync(base_dir, 0755);
  }

  console.log("Initial RC file at: ", rc_file)
  if (path.existsSync(rc_file)) {
    console.log(" - Already exists");
  } else {
    fs.writeFileSync(rc_file,
      'base = '+ base_dir
    );
  }

  console.log("Done");
}


/**
 * Initializes the task
 *
 * @param {Array} arguments
 * @return void
 */
exports.init = function(args) {
  bootstrap(args[0]);
};

exports.help = function(args) {
  console.log(
    "Bootstraps the LovelyIO infrastructure\n\n" +
    "Usage: lovely bootstrap [base-directory]"
  );
}