/**
 * Node.js envinronment initializer for Left.js
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var

fs  = require('fs'),
sys = require('sys'),


// packing and initializing LeftJS
dir = process.cwd() + "/src/",
modules = ['core', 'dom', 'old', 'form', 'ajax'],
sources = {}, i = 0, src;

for (; i < modules.length; i++) {
  src = fs.readFileSync(dir + modules[i] + '.js').toString();
  src = src.replace(/require\(['"](.+?)['"]\);/mg, function(m, filename) {
    return fs.readFileSync(dir + filename + '.js')
      .toString().replace(/($|\n)/g, '$1  ') + "\n\n";
  });

  sources[modules[i]] = src;

  fs.writeFileSync(process.cwd() + "/build/"+ modules[i] + "-src.js", src);

  if (modules[i] == 'core') {
    eval(src);
  }
}

exports.Source = sources;


// globalizing those ones so we didn't need to reinit them all the time
global.LeftJS  = LeftJS;
global.util    = require('util');
global.vows    = require('vows');
global.assert  = require('assert');

assert.same    = assert.strictEqual;
assert.notSame = assert.notStrictEqual;

/**
 * A simple shortcut over the Vows to make
 * a single batch descriptions
 *
 * @param {String} name
 * @param {Object} batch hash
 * @param {Object} current module
 * @return void
 */
global.describe = function(thing, batch, module) {
  vows.describe(thing).addBatch(batch).export(module);
}

// making a little local server with 'express' to load the fixtures into the zombie
var express = require('express');
var server  = express.createServer();

server.use(express.bodyParser());
server.use(express.cookieParser());

server.get('/', function(req, resp) {
  resp.send('<html><body>Hello</body></html>');
});

server.get('/left.js', function(req, resp) {
  resp.send(sources.core); // The LeftJS source
});

global.server = server;

/**
 * A shortcut to dynamically define the server responses
 *
 * @param {Object} routes and responses
 * @return {undefined}
 */
global.server_respond = function(defs) {
  for (var route in defs) {
    (function(route, response) {
      server.get(route, function(req, resp) {
        resp.send(response);
      });
    })(route, defs[route]);
  }
}

// a global zombie-browser reference
global.Browser = require('zombie').Browser;

/**
 * Our own shortcut for the browser load
 * so that you didn't need to carry around
 * the domain-name, port and things
 *
 * @param {String} relative url address
 * @param {Function} vows async callback
 */
Browser.open = function(url, callback) {
  if (!server.active) {
    server.listen(3000);
    server.active = true;
  }

  var browser = new Browser();

  browser.alerts = [];
  browser.onalert(function(message) {
    browser.alerts.push(message);
  });

  browser.visit('http://localhost:3000' + url, function(err, browser) {
    if (err) throw err;
    browser.wait(callback);
  });
}
