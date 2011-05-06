/**
 * Completely uninstalls all the Lovely IO files
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

function exec(cmd) {
  require('child_process').exec(cmd,
    function(error, stdout) {
      if (stdout || error) {
        console.log(stdout || error.message);
      }
    }
  );
}

exports.init = function(args) {
  console.log("Removing: ~/.lovely/");
  exec('rm -rf ~/.lovely');

  console.log("Removing: ~/.lovelyrc");
  exec('rm -rf ~/.lovelyrc');

  console.log("Done");
}