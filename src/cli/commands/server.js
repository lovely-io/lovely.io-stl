/**
 * The package local server. It builds a user's
 * package on fly alowing to effectively split it
 * apart and work with it in a nice environment
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
exports.init = function(args) {
  var fs      = require('fs');
  var source  = require('../source');
  var express = require('express');
  var server  = express.createServer();
  var minify  = false;

  // dynamically serving the main module script
  server.get('/main.js', function(req, res) {
    res.send(minify ? source.minify() : source.compile());
  });

  server.get('/lovely/:module.js', function(req, res) {
    // TODO make the modules hookable form here
    res.send(req.params.module);
  });

  server.get('/favicon.ico', function(req, res) {
    res.send('');
  });

  // listening all the pages in the user project
  server.get('/:page?', function(req, res) {
    minify = req.query.minify == 'true';
    res.send(fs.readFileSync(process.cwd() + '/' + (req.params.page || 'index') + '.html'));
  });


  server.listen(args[0] || 3000);

  console.log("Listening at: http://127.0.0.0:" + (args[0] || 3000));
};

exports.help = function(args) {
  console.log(
    "Runs a development server in a LovelyIO module project\n\n" +
    "Usage: lovely server [port]"
  );
}