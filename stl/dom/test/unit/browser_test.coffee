#
# The $.Browser hash tests
#
# Copyright (C) 2011-2012
#
{Browser} = require('../test_helper')

describe 'Browser', ->

  # user-agent strings
  user_agents =
    Unknown:      "Dummy browser"
    Opera:        "Opera/9.80 (Windows NT 6.0; U; en) Presto/2.8.99 Version/11.10"
    Gecko:        "Mozilla/5.0 (X11; U; Linux x86_64; pl-PL; rv:2.0) Gecko/20110307 Firefox/4.0"
    Konqueror:    "Mozilla/5.0 (compatible; Konqueror/4.5; FreeBSD) KHTML/4.5.4 (like Gecko)"
    MobileSafari: "Mozilla/5.0 (Linux; U; Android 2.2.1; fr-ch; A43 Build/FROYO) AppleWebKit/533.1" +
      " (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"

  for name of user_agents
    do (name)->
      it "should say it's '#{name}' for #{name} browser", (done)->
        Browser.open "/test.html", userAgent: user_agents[name], (browser)->
          browser.window.Lovely.module('dom').Browser.should.eql name
          done()
