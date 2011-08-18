#
# Default i18n hash for the dates
#
# Copyright (C) 2011 Nikolay Nemshilov
#
unless Date.i18n
  Date.i18n =
    days:        'Sunday Monday Tuesday Wednesday Thursday Friday Saturday'
    daysShort:   'Sun Mon Tue Wed Thu Fri Sat'
    daysMin:     'Su Mo Tu We Th Fr Sa'
    months:      'January February March April May June July August September October November December'
    monthsShort: 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'