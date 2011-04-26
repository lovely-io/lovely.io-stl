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
    '});',

  '/double.html':

    '<html><head>                                                   '+
    '  <script src="/left.js"></script>                             '+
    '  <script>                                                     '+
    '    LeftJS(["module5", "module5"], function(m1, m2) {          '+
    '    alert("Received: "+ m1);                                   '+
    '    alert("Received: "+ m2);                                   '+
    '    alert("Done!");                                            '+
    '  });                                                          '+
    '  </script>                                                    '+
    '</head></html>',

  '/local.html':

    '<html><head>                                                   '+
    '  <script src="/left.js"></script>                             '+
    '  <script>                                                     '+
    '    LeftJS(                                                    '+
    '      {baseUrl: "/my/scripts/"},                               '+
    '      ["module1", "./module6", "../../module8"],               '+
    '      function(m1, m6, m8) {                                   '+
    '        alert("Received: "+ m1);                               '+
    '        alert("Received: "+ m6);                               '+
    '        alert("Received: "+ m8);                               '+
    '        alert("Done!");                                        '+
    '      }                                                        '+
    '    );                                                         '+
    '  </script>                                                    '+
    '</head></html>',

  '/my/scripts/module6.js':

    'LeftJS("module6",                                              '+
    '  {baseUrl: "/other/scripts"},                                 '+
    '  ["./module7"], function(m7) {                                '+
    '    alert("Received: "+ m7);                                   '+
    '    alert("Initializing: module6");                            '+
    '    return "module6";                                          '+
    '  }                                                            '+
    ');',

  '/other/scripts/module7.js':

    'LeftJS("module7", function() {                                 '+
    '  alert("Initializing: module7");                              '+
    '  return "module7";                                            '+
    '});',

  '/module8.js':

    'LeftJS("module8", function() {                                 '+
    '  alert("Initializing: module8");                              '+
    '  return "module8";                                            '+
    '});'
});


describe('LeftJS', {
  'standard modules loading': {
    topic: function() {
      Browser.open('/load.html', this.callback);
    },

    'should load the scripts and initialize them in order': function(browser) {
      assert.deepEqual(browser.alerts, [
        'Initializing: module3',
        'Initializing: module4',
        'Initializing: module5',
        'Received: module5',
        'Initializing: module2',
        'Received: module3',
        'Received: module4',
        'Initializing: module1',
        'Received: module1',
        'Received: module2',
        'Done!'
      ]);
    }
  },

  'double loading attempt': {
    topic: function() {
      Browser.open('/double.html', this.callback);
    },

    'should not load the same module twice': function(browser) {
      assert.deepEqual(browser.alerts, [
        'Initializing: module5',
        'Received: module5',
        'Received: module5',
        'Done!'
      ]);
    }
  },

  'local modules loading': {
    topic: function() {
      Browser.open('/local.html', this.callback);
    },

    'should load local modules': function(browser) {
      assert.deepEqual(browser.alerts, [
        'Initializing: module8',
        'Initializing: module3',
        'Initializing: module4',
        'Initializing: module7',
        'Received: module7',
        'Initializing: module6',
        'Received: module3',
        'Received: module4',
        'Initializing: module1',
        'Received: module1',
        'Received: module6',
        'Received: module8',
        'Done!'
      ]);
    }
  }
}, module);
