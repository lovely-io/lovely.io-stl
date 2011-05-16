#
# This module defines the current browser abilites
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Browser = 'Unknown'

# a dummy browser guess by the userAgent parameter
Browser_agent = navigator.userAgent

Browser = 'IE'           if 'attachEvent' of document && !/Opera/.test(Browser_agent)
Browser = 'Opera'        if /Opera/.test(Browser_agent)
Browser = 'Gecko'        if /Gecko/.test(Browser_agent) && !/KHTML/.test(Browser_agent)
Browser = 'WebKit'       if /AppleWebKit/.test(Browser_agent)
Browser = 'MobileSafari' if /Apple.*Mobile.*Safari/.test(Browser_agent)
Browser = 'Konqueror'    if /Konqueror/.test(Browser_agent)


# a couple of internal markers to handle old browsers
Browser_IS_OLD = !document.querySelector
Browser_OLD_IE = false  # IE < 9

try
  document.createElement('<input/>')
  Browser_IS_OLD = Browser_OLD_IE = true

catch e
  # all normal browsers, including IE9 will fall on that

BROWSER_IE_OPACITY = !('opacity' of HTML.style) && 'filter' of HTML.style
