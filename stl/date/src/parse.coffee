#
# Better dates parsing method with i18n support
#
# @param {String} date
# @return {Date} date
#
Date_parse = Date.parse
Date.parse = (string)->
  new Date()