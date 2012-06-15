#
# Keeps the documentation generators code
#
# Copyrigth (C) 2012 Nikolay Nemshilov
#


#
# Coffee script docs generator
#
# @param {String} raw CoffeeScript
# @return {String} markdown
#
exports.from_coffee = (source)->
  return source