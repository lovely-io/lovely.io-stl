#
# Better dates parsing method with i18n support
#
# NOTE: when called with a format pattern, then will
#       return the actual `Date` class _instance_
#
# @param {String} date
# @param {String} pattern
# @return {Date|Integer} date or time
#
Date_parse = Date.parse # the original method
Date.parse = (string, format)->
  if format and typeof(string) is 'string'
    tpl     = re_escape(format)
    holders = L(tpl.match(/%[a-z]/ig)).map((m)-> m[1]).filter((m)-> m isnt '%')
    re      = new RegExp('^'+tpl.replace(/%p/i, '(pm|PM|am|AM)').replace(/(%[a-z])/ig, '(.+?)')+'$')
    year    = 0
    month   = 0
    date    = 1
    hour    = 0
    minute  = 0
    second  = 0

    if match = trim(string).match(re)
      match.shift()

      while match.length
        value  = match.shift()
        key    = holders.shift()

        if key.toLowerCase() is 'b'
          month = L(Date.i18n[if key is 'b' then 'monthNamesShort' else 'monthNames'].split(' ')).indexOf(value)
        else if key.toLowerCase() is 'p'
          meridian = value.toLowerCase()
        else
          value = parseInt(value, 10)
          switch key
            when 'd', 'e'           then date   = value
            when 'm'                then month  = value - 1
            when 'y', 'Y'           then year   = value
            when 'H', 'k', 'I', 'l' then hour   = value
            when 'M'                then minute = value
            when 'S'                then second = value

      # converting 1..12am|pm into 0..23 hours marker
      if meridian
        hour = if hour is 12 then 0 else hour
        hour = if meridian is 'pm' then hour + 12 else hour

      return new Date(year, month, date, hour, minute, second)

  else
    return Date_parse(string) # calling the original method