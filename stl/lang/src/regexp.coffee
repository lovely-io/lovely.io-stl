#
# The `RegExp` unit extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#


#
# Escapes the string for safely use as a regular expression
#
# @param {String} raw string
# @return {String} escaped string
#
RegExp.escape = (string)->
  (''+string).replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1')
