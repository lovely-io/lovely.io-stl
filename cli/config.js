/**
 * A nice proxy to ready/write configurations
 * from/into the ~/.lovelyrc file
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var lovelyrc = global.lovelyrc = {};
var location = process.env.HOME + '/.lovelyrc';
var options  = {}; // a local copy fo the options

/**
 * Making magic setters
 *
 * the basic idea is to provide a smart object
 * that will automatically save the options into
 * the ~/.lovelyrc file when the parameters
 * are changed.
 */
[
  'user', 'name', 'email', 'base', 'host', 'secret'
].forEach(function(key) {
  lovelyrc.__defineSetter__(key, function(value) {
    options[key] = value;
    save_options();
  });

  lovelyrc.__defineGetter__(key, function() {
    return options[key];
  });
});

/**
 * Saves the options into the ~/.lovelyrc file
 *
 * @return void
 */
function save_options() {
  var str = "# Lovely IO config (auto-generated)\n\n", key;

  for (key in options) {
    str += key + " = " + options[key] + "\n";
  }

  require('fs').writeFileSync(location, str);
}

// reading the current set of options if available
if (require('path').existsSync(location)) {
  require('fs')
    .readFileSync(location).toString()
    .replace(/(\w+)\s*=\s*([^\n]+)/g, function(m, key, value) {
      options[key] = value;
    });
}
