#
# Keeps the documentation generators code
#
# Copyrigth (C) 2012 Nikolay Nemshilov
#

#
# Generates a documentation string out of a file
#
# @param {String} filename
# @return {String|Boolean} documentation or `false` if not supported
#
exports.from_file = (filename)->
  content = require('fs').readFileSync(filename, "utf-8").toString()

  if /\.coffee/.test(filename)
    from_coffee(content)
  else
    false


#
# Coffee script docs generator
#
# @param {String} raw CoffeeScript
# @return {String} markdown
#
exports.from_coffee = from_coffee = (source)->
  in_comment = false
  lines      = source.split("\n")
  comment_re = /^\s*#/
  source     = ''

  for line, i in lines
    if /^\s*#+\s*$/.test(line) # comment start/end marker
      line = line.replace(/^\s*#+\s?/, '')

      if in_comment
        if comment_re.test(lines[i+1])
          source += "#{line}\n"
        else
          in_comment = false
          source += "#{line}\n```coffee\n"
      else
        in_comment = true
        source += "```\n" unless i is 0
        source += "#{line}\n"
    else if in_comment
      source += "#{line.replace(/^\s*#+\s?/, '')}\n"
    else
      source += "#{line}\n"

  source += "\n```" unless comment_re.test(line)

  source = source.replace(/\n```coffee\s+/g, "\n```coffee\n")
  source = source.replace(/\s+\n```(\n|$)/g, "\n```\n")

  source = source.replace(/^\s+|\s+$/, '')
