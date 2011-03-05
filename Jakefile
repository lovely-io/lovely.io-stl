/**
 * The `jake` tasks
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

desc('Runs the tests');
task('test', [], function() {
  system('vows test/*/*_spec.js');
});

namespace('test', function() {
  desc('Runs the tests with spec output');
  task('spec', [], function() {
    system('vows test/*/*_spec.js --spec');
  })
});

/**
 * A simple system-call wrapper
 *
 * @param {String} system cmd
 * @return void
 */
function system(cmd) {
  require('child_process').exec(cmd,
    function(error, stdout) {
      console.log(stdout || error.message);
    }
  );
}
