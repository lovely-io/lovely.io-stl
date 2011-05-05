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
 * @param {String} optional package directory file
 * @return {String} raw source code
 */
function compile(directory) {
  directory || (directory = process.cwd());
  directory = directory.replace(/\/$/, '');

  var source = fs.readFileSync(directory + "/main.js").toString();

  // inserting the related files
  source = source.replace(/(\n\s+)include\(['"](.+?)['"]\);/mg, function(m, spaces, filename) {
    return spaces + fs.readFileSync(directory + '/' + filename + '.js')
      .toString().replace(/($|\n)/g, '$1  ') + "\n\n";
  });

  // adding the package options
  var options = JSON.parse(fs.readFileSync(directory + "/package.json").toString());

  source = source.replace(/LeftJS\s*\(/, 'LeftJS("'+ options.name +'", ');
  source = source.replace('%{version}', options.version);

  return source + inline_css(directory);
}

/**
 * Minifies the source code
 *
 * @param {String} optional package directory file
 * @return {String} minified source code
 */
function minify(directory) {
  var source = compile(directory);
  var ugly   = require('uglify-js');
  var build  = ugly.parser.parse(source);

  build = ugly.uglify.ast_mangle(build);
  build = ugly.uglify.ast_squeeze(build);
  build = ugly.uglify.gen_code(build);

  // copying the header over
  build = source.match(/\/\*[\s\S]+?\*\/\s/m)[0] + build;

  return build;
}

/**
 * Embedds the styles as an inline javascript
 *
 * @param {String} package directory root
 * @return {String} inlined css
 */
function inline_css(directory) {
  try {
    style = fs.readFileSync(directory + '/main.css')
      .toString()

      // preserving IE hacks
      .replace(/\/\*\\\*\*\/:/g, '_ie8_s:')
      .replace(/\\9;/g, '_ie8_e;')

      // compacting the styles
      .replace(/\/\*[\S\s]*?\*\//img, '')
      .replace(/\n\s*\n/mg, "\n")
      .replace(/\s+/img, ' ')
      .replace(/\s*(\+|>|\||~|\{|\}|,|\)|\(|;|:|\*)\s*/img, '$1')
      .replace(/;\}/g, '}')
      .replace(/\)([^;}\s])/g, ') $1')
      .trim()

      // getting IE hacks back
      .replace(/([^\s])\*/g,   '$1 *')
      .replace(/_ie8_s:/g,     '/*\\\\**/:')
      .replace(/_ie8_e(;|})/g, '\\\\9$1')

      // escaping the quotes
      .replace(/"/, '\"');


    // making the JavaScript embedding script
    return style.match(/^\s*$/) ? '' : "\n\n// embedded css-styles    \n"+
      "(function(document) {                                          \n"+
      "  var style = document.createElement('style'),                 \n"+
      "      rules = document.createTextNode(\""+ style + "\");       \n"+
      "                                                               \n"+
      "  style.type = 'text/css';                                     \n"+
      "  document.getElementsByTagName('head')[0].appendChild(style); \n"+
      "                                                               \n"+
      "  if(style.styleSheet) {                                       \n"+
      "    style.styleSheet.cssText = rules.nodeValue;                \n"+
      "  } else {                                                     \n"+
      "    style.appendChild(rules);                                  \n"+
      "  }                                                            \n"+
      "})(document);                                                  \n";
  } catch (e) {
    return ''; // file doesn't exists
  }
}

exports.build  = compile;
exports.minify = minify;