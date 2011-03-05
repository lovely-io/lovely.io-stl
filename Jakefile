/**
 * The `jake` tasks
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

desc('Runs the tests');
task('test', [], function() {
  require('child_process').exec('vows test/*/*_spec.js --spec',
    function(error, stdout) { console.log(stdout);}
  );
});

