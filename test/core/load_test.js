/**
 * The modules loading/defining interface tests
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
require('../test_helper');

server_respond({
  '/load.html':

    '<html><head>                                                   '+
    '  <script src="/left.js"></script>                             '+
    '  <script>                                                     '+
    '    LeftJS(["module1", "module2"], function(m1, m2) {          '+
    '    alert("Received: "+ m1);                                   '+
    '    alert("Received: "+ m2);                                   '+
    '    alert("Done!");                                            '+
    '  });                                                          '+
    '  </script>                                                    '+
    '</head></html>',

  '/module1.js':

    'LeftJS("module1", ["module3", "module4"], function(m3, m4) {   '+
    '  alert("Received: "+ m3);                                     '+
    '  alert("Received: "+ m4);                                     '+
    '  alert("Initializing: module1");                              '+
    '  return "module1";                                            '+
    '});',

  '/module2.js':

    'LeftJS("module2", ["module5"], function(m5) {                  '+
    '  alert("Received: "+ m5);                                     '+
    '  alert("Initializing: module2");                              '+
    '  return "module2";                                            '+
    '});',

  '/module3.js':

    'LeftJS("module3", function() {                                 '+
    '  alert("Initializing: module3");                              '+
    '  return "module3";                                            '+
    '});',

  '/module4.js':

    'LeftJS("module4", function() {                                 '+
    '  alert("Initializing: module4");                              '+
    '  return "module4";                                            '+
    '});',

  '/module5.js':
    'LeftJS("module5", function() {                                 '+
    '  alert("Initializing: module5");                              '+
    '  return "module5";                                            '+
    '});'
});


describe('Load', {
  'loading': {
    topic: function() {
      Browser.open('/load.html', this.callback);
    },

    'should load the scripts and initialize them in order': function(browser) {
      assert.deepEqual(browser.alerts, [
        'Initializing: module3',
        'Initializing: module4',
        'Initializing: module5',
        'Received: module3',
        'Received: module4',
        'Initializing: module1',
        'Received: module5',
        'Initializing: module2',
        'Received: module1',
        'Received: module2',
        'Done!'
      ]);
    }
  }
}, module);
