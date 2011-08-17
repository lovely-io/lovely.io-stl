#
# Formats the date according to the POSIX pattern
#
# @param {String} pattern (POSIX)
# @return {String} formatted Date
#
Date.prototype.format = (pattern)->
  pattern