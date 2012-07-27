#
# The modules loading/defining interface tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Browser, Lovely} = require('../test_helper')

Browser.respond
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

  "/version-configured.html": """
  <html><head>
    <script src="/lovely.io/core.js"></script>
    <script>
      Lovely.bundle = {
        'versioned-module' : '2.0.0'
      };
      Lovely(['versioned-module'], function(m) {
        alert('Version '+ m.version);
      })
    </script>
  </head></html>
  """

  "/lovely.io/versioned-module.js": """
  Lovely('versioned-module', function() {
    return { version: '0.0.0' };
  });
  """

  "/lovely.io/versioned-module-1.0.0.js": """
  Lovely('versioned-module-1.0.0', function() {
    return { version: '1.0.0' };
  });
  """

  "/lovely.io/versioned-module-2.0.0.js": """
  Lovely('versioned-module-2.0.0', function() {
    return { version: '2.0.0' };
  });
  """

describe 'Lovely AMD', ->
  it 'should find itself by a short name', ->
    Lovely.module('core').should.equal Lovely

  it 'should find itself by a long name', ->
    Lovely.module("core-#{Lovely.version}").should.equal Lovely

  it "should return nothing if a module doesn't exist", ->
    (Lovely.module('unknown') is undefined).should.be.true

  it 'should load the scripts and initialize them in order', (done)->
    Browser.open '/load.html', (browser)->

      browser.alerts.sort().should.eql [
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

      done()

  it 'should not load the same module twice', (done)->
    Browser.open '/double.html', (browser)->
      browser.alerts.sort().should.eql [
        'Initializing: module5',
        'Received: module5',
        'Received: module5',
        'Done!'
      ].sort()

      done()

  it 'should load local modules', (done)->
    Browser.open '/local.html', (browser)->
      browser.alerts.sort().should.eql [
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
      done()

  it "should still load everything properly", (done)->
    Browser.open '/relocated.html', (browser) ->
      browser.alerts.should.eql [
        'Initializing: m11',
        'Initializing: m12',
        'Received: m11',
        'Received: m12',
        'Done!'
      ]
      done()


  it "should load the bundled version", (done)->
    Browser.open '/version-configured.html', (browser)->
      browser.alerts.should.eql [
        'Version 2.0.0'
      ]
      done()

