# Date

`Date` is a set of extensions to the native `Date` unit to support
additional things like POSIX style dates formatting, initialization
and so on

    :javascript
    Lovely(['date'], function() {
      var date = new Date();
      date.format('%Y-%m-%d'); // -> '2011-08-18'

      var date = Date.parse('January 10, 1999', '%B %d, %Y');
      date instanceof Date;  // -> true!
    });



## Formatting keys

This extension generally uses the POSIX date formatting keys

 * `%a` - The abbreviated weekday name (`'Sun'`)
 * `%A` - The  full  weekday  name (`'Sunday'`)
 * `%b` - The abbreviated month name (`'Jan'`)
 * `%B` - The  full  month  name (`'January'`)
 * `%d` - Day of the month (`01..31`)
 * `%e` - Day of the month without leading zero (`1..31`)
 * `%m` - Month of the year (`01..12`)
 * `%y` - Year without a century (`00..99`)
 * `%Y` - Year with century
 * `%H` - Hour of the day, 24-hour clock (`00..23`)
 * `%k` - Hour of the day, 24-hour clock without leading zero (`0..23`)
 * `%I` - Hour of the day, 12-hour clock (`01..12`)
 * `%l` - Hour of the day, 12-hour clock without leading zero (`0..12`)
 * `%p` - Meridian indicator (`'AM'` or `'PM'`)
 * `%P` - Meridian indicator (`'pm'` or `'pm'`)
 * `%M` - Minute of the hour (`00..59`)
 * `%S` - Second of the minute (`00..60`)
 * `%%` - Literal `'%'` character


## I18n Support

You also can use i18n with this module

    :javascript
    Date.i18n = {
      days:        'Воскресенье Понедельник Вторник Среда Четверг Пятница Суббота'
      daysShort:   'Вск Пнд Втр Срд Чтв Птн Суб'
      months:      'Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'
      monthsShort: 'Янв Фев Мар Апр Май Инь Иль Авг Сен Окт Ноя Дек'
    };

    new Date().format('%A %e %B, %Y'); // -> "Четверг 18 Августа, 2011"
    Date.parse("Четверг 18 Августа, 2011", '%A %e %B, %Y'); // -> Date



## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov