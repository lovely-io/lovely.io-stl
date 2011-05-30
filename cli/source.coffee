#
# This module handles source code compilation
# for a standard project
#
# Copyright (C) 2011 Nikolay Nemshilov
#
fs   = require('fs')
path = require('path')

#
# Builds the actual source code of the current project
#
# @param {String} package directory root
# @return {String} raw source code
#
compile = (directory)->
  directory or= process.cwd()

  options = require('./package').read(directory)
  format  = path.existsSync("#{directory}/main.coffee")
  format  = if format then 'coffee' else 'js'
  source  = fs.readFileSync("#{directory}/main.#{format}").toString()

  # inserting the related files
  source = source.replace /(\n([ \t]*))include[\(| ]+['"](.+?)['"][\)]*/mg,
    (m, start, spaces, filename) ->
      start + fs.readFileSync("#{directory}/#{filename}.#{format}")
      .toString().replace(/($|\n)/g, '$1'+spaces) + "\n\n"

  # converting coffee into javascript if needed
  if format is 'coffee'
    # hijacking the Coffee's class definitions and converting them in our classes
    source = source.replace /(\n\s*)class\s+([^\s]+)(\s+extends\s+([^\s]+))?/g,
      (match, start, Klass, smth, Super)->
        if !Super then "#{start}#{Klass} = new Class"
        else "#{start}#{Klass} = new Class #{Super},"

    # replacing teh Coffee's 'super' calls with our own class calls
    source = source.replace /([^\w$\.])super(\(|\s)(.*?)([\)\n;])/g,
      (match, start, b1, params, b2)->
        "#{start}this.$super(#{params});"

    # building the basic scripts
    source = require('coffee-script').compile(source, {bare: true})

    # fixing coffee's void(0) hack back to `undefined`
    source = source.replace /([^a-z0-9\_]+)void\s+0([^a-z0-9]+)/ig, '$1undefined$2'


  # adding the class names to the constructor functions
  source = source.replace /([^\s]+)(\s*=\s*new\s+Class\()((.|\n)+?constructor:\s+function\s*\()/mg,
    (match, Klass, first, second)->
      if second.indexOf('new Class') is -1 and second.match(/constructor:\s+function\s*\(/).length is 1
        second = second.replace(/(constructor:\s+function)(\s*\()/, '$1 '+Klass.replace('.', '_')+'$2')
        "#{Klass}#{first}#{second}"
      else match.toString()



  # adding the package dependencies
  source = source.replace('%{version}', options.version)

  # creating a standard AMD layout
  if options.name is 'core' # core doesn't use AMD
    source = """
    (function(undefined) {
      var global = this;
      #{source.replace(/(\n)/g, '$1  ')}
    }).apply(this)
    """

  else
    # extracting the 'require' modules to make dependencies
    dependencies = []
    source = source.replace /([^a-z0-9_\-\.])require\(('|")([^\.].+?)\2\)/ig,
      (match, start, quote, module)->
        if module is 'core'
          return "#{start}global.Lovely"
        else
          dependencies.push(module)
          return "#{start}global.Lovely.modules['#{module}']"

    # adding the 'exports' object
    if /[^a-z0-9_\-\.]exports[^a-z0-9\_\-]/i.test(source)
      source = "var exports = {};\n\n#{source}\n\nreturn exports;"

    # adding the 'global' object
    if /[^a-z0-9_\-\.]global[^a-z0-9\_\-]/i.test(source)
      source = "var global = this;\n"+ source

    # creating the Lovely(....) definition
    source = """
      Lovely("#{options.name}", [#{"'#{name}'" for name in dependencies}], function(undefined) {
        #{source.replace(/(\n)/g, "$1  ")}
      });
      #{inline_css(directory)}
      """

  # creating a standard header block
  source = """
  /**
   * lovely.io '#{options.name}' module v#{options.version}
   *
   * Copyright (C) #{new Date().getFullYear()} #{options.author}
   */
  #{source}
  """


#
# Minifies the source code
#
# @param {String} package directory root
# @return {String} minified source code
#
minify = (directory)->
  source = compile(directory)
  ugly   = require('uglify-js')
  build  = ugly.parser.parse(source)

  build  = ugly.uglify.ast_mangle(build)
  build  = ugly.uglify.ast_squeeze(build)
  build  = ugly.uglify.gen_code(build)

  # fixing the ugly `== 'string'` fuckups back to `=== 'string'`
  build  = build.replace(/(typeof [a-z]+)==("[a-z]+")/g, '$1===$2')

  # copying the header over
  (source.match(/\/\*[\s\S]+?\*\/\s/m) || [''])[0] + build


#
# Embedds the styles as an inline javascript
#
# @param {String} package directory root
# @return {String} inlined css
#
inline_css = (directory) ->
  for format in ['css', 'sass', 'styl']
    if path.existsSync("#{directory}/main.#{format}")
      style = fs.readFileSync("#{directory}/main.#{format}").toString()

  return "" if !style

  # converting from various formats
  if format is 'sass'
    style = require('sass').render(style)
  else if format is 'styl'
    require('stylus').render style, (err, src) ->
      if err then console.log(err) else style = src


  # minfigying the stylesheets
  style = style

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

  return "" if /^\s*$/.test(style) # no need to wrap an empty style

  """

  // embedded css-styles
  (function(document) {
    var style = document.createElement('style');
    var rules = document.createTextNode("#{style}");

    style.type = 'text/css';
    document.getElementsByTagName('head')[0].appendChild(style);

    if (style.styleSheet) {
      style.styleSheet.cssText = rules.nodeValue;
    } else {
      style.appendChild(rules);
    }
  })(this.document);
  """

exports.compile = compile
exports.minify  = minify