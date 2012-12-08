#
# This module handles source code compilation
# for a standard project
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

fs   = require('fs')

#
# Preconverts coffe-script into javascript
#
# @param {String} CoffeeScript
# @param {String} patch
# @return {String} JavaScript
#
convert_from_coffee = (source, patch)->
  if patch
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
  source.replace /([^a-z0-9\_]+)void\s+0([^a-z0-9]+)/ig, '$1undefined$2'


#
# Adds function names to the constructors so that
# they appeared correctly in the debugging console
#
# @param {String} original
# @return {String} patched
#
add_constructor_names = (source)->
  source.replace /([a-zA-Z0-9_$]+)(\s*=\s*new\s+Class\()((.|\n)+?constructor:\s*function\s*\()/mg,
    (match, Klass, first, second)->
      if second.indexOf('new Class') is -1 and second.match(/constructor:\s*function\s*\(/).length is 1
        second = second.replace(/(constructor:\s*function)(\s*\()/, '$1 '+Klass.replace('.', '_')+'$2')
        "#{Klass}#{first}#{second}"
      else match.toString()

#
# Assembles the main source file and converts it into javascript
#
# @param {String} original coffeescript
# @param {String} format name
# @param {Boolean} patch for Lovely.IO module
# @return {String} piece of javascript
#
assemble = (source, format, directory, patch)->
  directory or= process.cwd()

  # inserting the related files
  source = source.replace /(\n([ \t]*))include[\(| ]+['"](.+?)['"](\);|\))?/mg,
    (m, start, spaces, filename) ->
      start + fs.readFileSync("#{directory}/#{filename}.#{format}")
      .toString().replace(/($|\n)/g, '$1'+spaces) + "\n\n"

  if format is 'coffee' then convert_from_coffee(source, patch) else source


#
# Builds the actual source code of the current project
#
# @param {String} package directory root
# @param {Boolean} vanilla (non lovely.io) module build
# @param {Boolean} send `true` if you don't want the styles to be emebedded in the build
# @return {String} raw source code
#
compile = (directory, vanilla, no_style)->
  directory or= process.cwd()

  options = require('./package').read(directory, vanilla) || {}
  format  = if fs.existsSync("#{directory}/main.coffee") then 'coffee' else 'js'
  source  = fs.readFileSync("#{directory}/main.#{format}").toString()

  # assembling the file with others
  source  = assemble(source, format, directory, true)

  # adding the class names to the constructor functions
  source = add_constructor_names(source)

  # adding the package dependencies
  source = source.replace('%{version}', options.version)

  # vanilla, no lovely.io builds
  if vanilla || !options.name
    if options.name
      header = "/**\n * #{options.name}"
      header += " v#{options.version}" if options.version
      header += "\n *\n * #{options.description}" if options.description
      header += "\n *\n * Copyright (C) #{new Date().getFullYear()} #{options.author}" if options.author
      header += "\n */\n"
    else
      header = ""


    return header + """
    (function (undefined) {
      #{source.replace(/(\n)/g, '$1  ')}
    }).apply(this);
    #{if no_style then '' else inline_css(directory, true)}
    """

  # creating a standard AMD layout
  else if options.name is 'core' # core doesn't use AMD
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
        if options.dependencies and options.dependencies[module]
          module += "-#{options.dependencies[module]}"
        dependencies.push(module) unless module is 'core' # default core shouldn't be on the list
        return "#{start}Lovely.module('#{module}')"

    # adding the 'exports' object
    if /[^a-z0-9_\-\.]exports[^a-z0-9\_\-]/i.test(source)
      source = "var exports = {};\n\n"+ source;

    # adding the 'global' object
    if /[^a-z0-9_\-\.]global[^a-z0-9\_\-]/i.test(source)
      source = "var global = this;\n"+ source

    # creating the Lovely(....) definition
    module_name = options.name
    module_name+= "-#{options.version}" if options.version
    source = """
      Lovely("#{module_name}", [#{"'#{name}'" for name in dependencies}], function() {
        var undefined = [][0];
        #{source.replace(/(\n)/g, "$1  ")}

        #{if source.indexOf('var exports = {};') > -1 then "return exports;" else ""}
      });
      #{if no_style then '' else inline_css(directory)}
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
# @param {Boolean} vanilla (non lovely.io) module build
# @param {Boolean} send `true` if you don't want the styles to be emebedded in the build
# @return {String} minified source code
#
minify = (directory, vanilla, no_style)->
  source = compile(directory, vanilla, no_style)
  ugly   = require('uglify-js')
  build  = ugly.parse(source)
  output = ugly.OutputStream()
  except = ['Class']

  # extracting the exported class names so they didn't get mangled
  if match = source.match(/((ext\(\s*exports\s*,)|(\n\s+exports\s*=\s*))[^;]+?;/mg)
    for name in match[0].match(/[^a-zA-Z0-9_$][A-Z][a-zA-Z0-9_$]+/g) || []
      except.push(name.substr(1)) if except.indexOf(name.substr(1)) is -1

  build.figure_out_scope()
  build = build.transform(new ugly.Compressor(warnings: false))

  build.figure_out_scope()
  build.compute_char_frequency()
  build.mangle_names(except: except)

  build.print(output)

  build = output.get()

  # fixing the ugly `'string'==` fuckups back to `'string' === `
  build  = build.replace(/("[a-z]+")(\!|=)=(typeof [a-z_$]+)/g, '$1$2==$3')

  # getting back the constructor names
  build  = add_constructor_names(build)

  # copying the header over
  (source.match(/\/\*[\s\S]+?\*\/\s/m) || [''])[0] + build


#
# Converts various formats into vanilla CSS
#
# @param {String} original code
# @param {String} format 'sass', 'scss', 'styl', 'css'
#
build_style = (style, format)->
  if format in ['sass', 'styl']
    require('stylus').render style, (err, css) ->
      if err then console.log(err) else style = css

  if format is 'scss'
    require('node-sass').render style, (err, css)->
      if err then console.log(err) else style = css

  return style


#
# Embedds the styles as an inline javascript
#
# @param {String} package directory root
# @return {String} inlined css
#
inline_css = (directory, not_lovely) ->
  for format in ['css', 'sass', 'styl', 'scss']
    if fs.existsSync("#{directory}/main.#{format}")
      style = fs.readFileSync("#{directory}/main.#{format}").toString()
      break

  return "" if !style

  # minfigying the stylesheets
  style = build_style(style, format)

  # preserving IE hacks
  .replace(/\/\*\\\*\*\/:/g, '_ie8_s:')
  .replace(/\\9;/g, '_ie8_e;')

  # compacting the styles
  .replace(/\\/g, "\\\\")
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
    (function() {
      var style = document.createElement('style');
      var rules = document.createTextNode("#{style}")#{if not_lovely then '' else ".replace(/url\\(\"\\//g, 'url(\"'+ Lovely.hostUrl)"};

      style.type = 'text/css';
      document.getElementsByTagName('head')[0].appendChild(style);

      if (style.styleSheet) {
        style.styleSheet.cssText = rules.nodeValue;
      } else {
        style.appendChild(rules);
      }
    })();

  """

exports.assemble = assemble
exports.compile  = compile
exports.minify   = minify
exports.style    = build_style