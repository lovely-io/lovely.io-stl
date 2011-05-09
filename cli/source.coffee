#
# This module handles source code compilation
# for a standard project
#
# Copyright (C) 2011 Nikolay Nemshilov
#
fs = require('fs')

#
# Builds the actual source code of the current project
#
# @return {String} raw source code
#
compile = ->
  directory = process.cwd()
  options   = require('./package')
  source    = fs.readFileSync("#{directory}/main.js").toString()

  # inserting the related files
  source = source.replace /(\n\s+)include\(['"](.+?)['"]\);/mg, (m, spaces, filename) ->
    spaces + fs.readFileSync("#{directory}/#{filename}.js")
    .toString().replace(/($|\n)/g, '$1  ') + "\n\n"

  # adding the package options
  source = source.replace(/Lovely\s*\(\s*\[/, "Lovely('#{options.name}', [")
  source = source.replace('%{version}', options.version)

  # inlining the styles where available
  source + inline_css(directory)


#
# Minifies the source code
#
# @return {String} minified source code
#
minify = ->
  source = compile()
  ugly   = require('uglify-js')
  build  = ugly.parser.parse(source)

  build  = ugly.uglify.ast_mangle(build)
  build  = ugly.uglify.ast_squeeze(build)
  build  = ugly.uglify.gen_code(build)

  # copying the header over
  source.match(/\/\*[\s\S]+?\*\/\s/m)[0] + build


#
# Embedds the styles as an inline javascript
#
# @param {String} package directory root
# @return {String} inlined css
#
inline_css = (directory) ->
  try
    style = fs.readFileSync("#{directory}/main.css").toString()

    # preserving IE hacks
    .replace(/\/\*\\\*\*\/:/g, '_ie8_s:')
    .replace(/\\9;/g, '_ie8_e;')

    # compacting the styles
    .replace(/\/\*[\S\s]*?\*\//img, '')
    .replace(/\n\s*\n/mg, "\n")
    .replace(/\s+/img, ' ')
    .replace(/\s*(\+|>|\||~|\{|\}|,|\)|\(|;|:|\*)\s*/img, '$1')
    .replace(/;\}/g, '}')
    .replace(/\)([^;}\s])/g, ') $1')
    .trim()

    # getting IE hacks back
    .replace(/([^\s])\*/g,   '$1 *')
    .replace(/_ie8_s:/g,     '/*\\\\**/:')
    .replace(/_ie8_e(;|})/g, '\\\\9$1')

    # escaping the quotes
    .replace(/"/g, '\\"')


    # making the JavaScript embedding script
    if style.match(/^\s*$/) then '' else """
      // embedded css-styles
      (function(document) {
        var style = document.createElement('style'),
            rules = document.createTextNode("#{style}");

        style.type = 'text/css';
        document.getElementsByTagName('head')[0].appendChild(style);

        if(style.styleSheet) {
          style.styleSheet.cssText = rules.nodeValue;
        } else {
          style.appendChild(rules);
        }
      })(document);
      """
  catch e
    "" # file doesn't exists

exports.compile = compile
exports.minify  = minify