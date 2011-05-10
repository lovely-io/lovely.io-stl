#
# The Function class extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
ext Function.prototype,
  delay: (ms) ->
    setTimeout this, ms

  periodical: (ms) ->
    setInterval this, ms