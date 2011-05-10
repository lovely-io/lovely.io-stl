#
# The 'Array' unit extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
ext Array.prototype,

  includes: (item) ->
    this.indexOf(item) isnt -1