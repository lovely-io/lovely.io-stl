#
# The $.Browser hash tests
#
# Copyright (C) 2011
#
{describe, assert, Browser} = require('../test_helper')

# user-agent strings
user_agents =
  Dummy:        "Dummy browser"
  Opera:        "Opera/9.80 (Windows NT 6.0; U; en) Presto/2.8.99 Version/11.10"
  Gecko:        "Mozilla/5.0 (X11; U; Linux x86_64; pl-PL; rv:2.0) Gecko/20110307 Firefox/4.0"
  Konqueror:    "Mozilla/5.0 (compatible; Konqueror/4.5; FreeBSD) KHTML/4.5.4 (like Gecko)"
  MobileSafari: "Mozilla/5.0 (Linux; U; Android 2.2.1; fr-ch; A43 Build/FROYO) AppleWebKit/533.1" +
    " (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"

# a shortcut to load the test page with differet user-agents
load_as = (user_agent, callback) ->
  Browser.open "/test.html", userAgent: user_agents[user_agent], (err, browser) ->
    callback(err, browser.window.Lovely.modules.dom.Browser)


describe 'Browser', module,
  "With a dummy browser":
    topic: -> load_as('Dummy', @callback)

    "should say it's 'Unknown'": (Browser) ->
      assert.equal Browser, 'Unknown'

### due an issue with Zombie https://github.com/assaf/zombie/issues/134

  "With an Opera":
    topic: -> load_as('Opera', @callback)

    "should say it's an Opera": (Browser) ->
      assert.equal Browser, 'Opera'

  "With Gecko":
    topic: -> load_as("Gecko", @callback)

    "should say it's a Gecko": (Browser) ->
      assert.equal Browser, 'Gecko'
###