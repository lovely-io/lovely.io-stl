/**
 * This module handling the source code compilation
 * for a standard project
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
var fs = require('fs');

/**
 * Builds the actual source code of the current project
 *
 * @return {String} raw source code
 */
function compile() {
  var source = fs.readFileSync(process.cwd() + "/index.js").toString();

  // inserting the related files
  source = source.replace(/(\n\s+)include\(['"](.+?)['"]\);/mg, function(m, spaces, filename) {
    return spaces + fs.readFileSync(process.cwd() + '/' + filename + '.js')
      .toString().replace(/($|\n)/g, '$1  ') + "\n\n";
  });

  // TODO inline CSS in here

  // adding the package options
  var options = JSON.parse(fs.readFileSync(process.cwd() + "/package.json").toString());

  source = source.replace(/LeftJS\s*\(/, 'LeftJS("'+ options.name +'", ');
  source = source.replace('%{version}', options.version);

  return source;
}

/**
 * Minifies the source code
 *
 * @return {String} minified source code
 */
function minify() {
  var source = compile();
  var ugly   = require('uglify-js');
  var build = ugly.parser.parse(source);

  build = ugly.uglify.ast_mangle(build);
  build = ugly.uglify.ast_squeeze(build);
  build = ugly.uglify.gen_code(build);

  // copying the header over
  build = source.match(/\/\*[\s\S]+?\*\/\s/m)[0] + build;

  return build;
}

exports.build  = compile;
exports.minify = minify;