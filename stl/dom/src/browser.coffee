#
# This module defines the current browser abilites
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Browser_agent = navigator.userAgent
console.log(Browser_agent)
Browser =
  IE:           'attachEvent' in document && !/Opera/.test(Browser_agent)
  Opera:        /Opera/.test(Browser_agent)
  Gecko:        /Gecko/.test(Browser_agent) && !/KHTML/.test(Browser_agent)
  WebKit:       /AppleWebKit/.test(Browser_agent)
  MobileSafari: /Apple.*Mobile.*Safari/.test(Browser_agent)
  Konqueror:    /Konqueror/.test(Browser_agent)

  # an internal marker for browsers that needs to load the 'olds' patch
  OLD:          !document.querySelector


try
  document.createElement('<input/>')
  Browser.OLD = true

catch e
  # all normal browsers, including IE9 will fall on that