This module tries to figure out the current browser type

__NOTE__: it's just a dummy `userAgent` based check

    Lovely ['dom'], ($)->
      if $.Browser is 'IE'
        alert("Cry baby cry!")

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
Browser = navigator.userAgent

if 'attachEvent' of document && !/Opera/.test(Browser)
  Browser = 'IE'
else if /Opera/.test(Browser)
  Browser = 'Opera'
else if /Gecko/.test(Browser) && !/KHTML/.test(Browser)
  Browser = 'Gecko'
else if /Apple.*Mobile.*Safari/.test(Browser)
  Browser = 'MobileSafari'
else if /Konqueror/.test(Browser)
  Browser = 'Konqueror'
else if /AppleWebKit/.test(Browser)
  Browser = 'WebKit'
else
  Browser = 'Unknown'
```
