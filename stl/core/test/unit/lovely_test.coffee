#
# The modules loading/defining interface tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, Browser, server} = require('../test_helper')

server.respond
  '/load.html': """
   <html><head>
    <script src="/core.js"></script>
    <script>
      Lovely(["module1", "module2"], function(m1, m2) {
      alert("Received: "+ m1);
      alert("Received: "+ m2);
      alert("Done!");
    });
    </script>
  </head></html>
  """

  '/module1.js': """
  Lovely("module1", ["module3", "module4"], function(m3, m4) {
    alert("Received: "+ m3);
    alert("Received: "+ m4);
    alert("Initializing: module1");
    return "module1";
  });
  """

  '/module2.js': """
  Lovely("module2", ["module5"], function(m5) {
    alert("Received: "+ m5);
    alert("Initializing: module2");
    return "module2";
  });
  """

  '/module3.js': """
  Lovely("module3", function() {
    alert("Initializing: module3");
    return "module3";
  });
  """

  '/module4.js': """
  Lovely("module4", function() {
    alert("Initializing: module4");
    return "module4";
  });
  """

  '/module5.js': """
  Lovely("module5", function() {
    alert("Initializing: module5");
    return "module5";
  });
  """

  '/double.html': """
  <html><head>
    <script src="/core.js"></script>
    <script>
      Lovely(["module5", "module5"], function(m1, m2) {
        alert("Received: "+ m1);
        alert("Received: "+ m2);
        alert("Done!");
      });
    </script>
  </head></html>
  """

  '/local.html': """
  <html><head>
    <script src="/core.js"></script>
    <script>
      Lovely(
        {baseUrl: "/my/scripts/"},
        ["module1", "./module6", "../../module8"],
        function(m1, m6, m8) {
          alert("Received: "+ m1);
          alert("Received: "+ m6);
          alert("Received: "+ m8);
          alert("Done!");
        }
      );
    </script>
  </head></html>
  """

  '/my/scripts/module6.js': """
  Lovely("module6",
    {baseUrl: "/other/scripts"},
    ["./module7"], function(m7) {
      alert("Received: "+ m7);
      alert("Initializing: module6");
      return "module6";
    }
  );
  """

  '/other/scripts/module7.js': """
  Lovely("module7", function() {
    alert("Initializing: module7");
    return "module7";
  });
  """

  '/module8.js': """
  Lovely("module8", function() {
    alert("Initializing: module8");
    return "module8";
  });
  """

  "/relocated.html": """
  <html><head>
    <script src="/lovely.io/core.js"></script>
    <script>
      Lovely(['module11', 'module12'], function(m1, m2) {
        alert("Received: "+ m1);
        alert("Received: "+ m2);
        alert("Done!");
      });
    </script>
  </head></html>
  """

  "/lovely.io/core.js": require('../../../../cli/source').compile(__dirname + "/../../")

  "/lovely.io/module11.js": """
  Lovely('module11', function() {
    alert("Initializing: m11");
    return "m11";
  });
  """

  "/lovely.io/module12.js": """
  Lovely('module12', function() {
    alert("Initializing: m12");
    return "m12";
  });
  """


describe 'Lovely', module,

  'standard modules loading':
    topic: -> Browser.open('/load.html', this.callback)

    'should load the scripts and initialize them in order': (browser) ->
      assert.deepEqual browser.alerts.sort(), [
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
      ].sort()

  'double loading attempt':
    topic: -> Browser.open('/double.html', this.callback)

    'should not load the same module twice': (browser) ->
      assert.deepEqual browser.alerts.sort(), [
        'Initializing: module5',
        'Received: module5',
        'Received: module5',
        'Done!'
      ].sort()

  'local modules loading':
    topic: -> Browser.open('/local.html', this.callback)

    'should load local modules': (browser) ->
      assert.deepEqual browser.alerts.sort(), [
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
      ].sort()

  'different host location':
    topic: -> Browser.open('/relocated.html', @callback)

    "should still load everything properly": (browser) ->
      assert.deepEqual browser.alerts, [
        'Initializing: m11',
        'Initializing: m12',
        'Received: m11',
        'Received: m12',
        'Done!'
      ]

