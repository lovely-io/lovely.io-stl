/**
 * The `jake` tasks
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

desc('Builds the script');
task('build', [], function() {
  var disc   = require('fs');
  var packer = require('uglify-js');
  var source = require('./test/test_helper').Src;
  var build  = packer.compress(source);

  // copying the header over
  build = source.match(/\/\*[\s\S]+?\*\/\s/m)[0] + build;

  system('mkdir -p build/');

  disc.writeFileSync('build/left.js', build);
  disc.writeFileSync('build/left-src.js', source);

  system('gzip -c build/left.js > build/left.js.gz');
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
