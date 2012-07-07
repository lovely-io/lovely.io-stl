Formats the date according to the POSIX pattern

@param {String} pattern (POSIX)
@return {String} formatted Date

```coffee-aside
Date.prototype.format = (pattern)->
  day    = @getDay()
  month  = @getMonth()
  date   = @getDate()
  year   = @getFullYear()
  hour   = @getHours()
  minute = @getMinutes()
  second = @getSeconds()

  hour_ampm = if hour == 0 then 12 else if hour < 13 then hour else hour - 12

  values =
    a: Date.i18n.daysShort.split(' ')[day]
    A: Date.i18n.days.split(' ')[day]
    b: Date.i18n.monthsShort.split(' ')[month]
    B: Date.i18n.months.split(' ')[month]
    d: zerofy(date)
    e: ''+date
    m: (if month < 9 then '0' else '') + (month+1)
    y: (''+year).substring(2,4)
    Y: ''+year
    H: zerofy(hour)
    k: '' + hour
    I: (if hour > 0 && (hour < 10 || (hour > 12 && hour < 22)) then '0' else '') + hour_ampm
    l: '' + hour_ampm
    p: if hour < 12 then 'AM' else 'PM'
    P: if hour < 12 then 'am' else 'pm'
    M: zerofy(minute)
    S: zerofy(second)
    '%': '%'

  for key of values
    pattern = pattern.replace('%'+key, values[key])

  pattern
```
