/**
 * Package files parser/validator
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

function Package(filename) {
  var fs = require("fs");
  var data = JSON.parse(fs.readFileSync(filename).toString());

  for (var key in data) {
    this[key] = data[key];
  }
}

Package.prototype.validate = function() {
  this.valid = true;

  this.name        || this.fail("miss the 'name' field");
  this.version     || this.fail("miss the 'version' field");
  this.description || this.fail("miss the 'description' field");
  this.author      || this.fail("miss the 'author' field");
  this.license     || this.fail("miss the 'license' field");

  this.version.match(/^\d+\.\d+\.\d+$/) ||
    this.fail("'version' should match the 'd+.d+.d+' format");

  return this;
};

Package.prototype.fail = function(message) {
  this.valid = false;
  this.errors || (this.errors = []);
  this.errors.push(message);
};

Package.prototype.dump = function() {
  console.log(
    "Failed to parse the 'package.json' file:\n",
    this.errors.join("\n")
  );
}


exports.parse = function(filename) {
  return new Package(filename).validate();
};