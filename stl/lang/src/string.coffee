#
# String class extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
ext String.prototype,

  includes: (string) ->
    this.indexOf(string) isnt -1