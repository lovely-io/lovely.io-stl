/**
 * The `jake` tasks
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

desc('Runs the tests');
task('test', [], function() {
  require('child_process').exec('vows test/*/*_spec.js',
    function(error, stdout) { console.log(stdout);}
  );
});

namespace('test', function() {
  desc('Runs the tests with spec output');
  task('spec', [], function() {
    require('child_process').exec('vows test/*/*_spec.js --spec',
      function(error, stdout) { console.log(stdout);}
    );
  })
});
