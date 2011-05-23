#
# This module tries to figure out the current browser type
#
# NOTE: it's just a dummy `userAgent` based check
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Browser = navigator.userAgent

if 'attachEvent' of document && !/Opera/.test(Browser)
  Browser = 'IE'
else if /Opera/.test(Browser)
  Browser = 'Opera'
else if /Gecko/.test(Browser) && !/KHTML/.test(Browser)
  Browser = 'Gecko'
else if /AppleWebKit/.test(Browser)
  Browser = 'WebKit'
else if /Apple.*Mobile.*Safari/.test(Browser)
  Browser = 'MobileSafari'
else if /Konqueror/.test(Browser)
  Browser = 'Konqueror'
else
  Browser = 'Unknown'


BROWSER_IS_OLD = !document.querySelector

# IE 8 or older check
try
  document.createElement('<input/>')
  BROWSER_IS_OLD_IE = true
  BROWSER_IS_OLD    = true
catch e
  BROWSER_IS_OLD_IE = false