/**
 * The `jake` tasks
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

desc('Builds the script');
task('build', [], function() {
  system('mkdir -p build/');

  require('fs').writeFileSync(
    'build/left.js',
    require('./test/init').Src
  );
});


desc('Runs the tests');
task('test', [], function() {
  system('vows test/*/*_test.js');
});

namespace('test', function() {
  desc('Runs the tests with spec output');
  task('spec', [], function() {
    system('vows test/*/*_test.js --spec');
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
      if (stdout || error) {
        console.log(stdout || error.message);
      }
    }
  );
}
