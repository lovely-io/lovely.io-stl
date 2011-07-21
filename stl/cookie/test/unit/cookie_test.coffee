#
# The Cookie unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

Cookie = Lovely.modules.cookie

# mocking the document cookie reference
cookie = null
Cookie.Options.document = {}
Cookie.Options.document.__defineSetter__ 'cookie', (value)->
  cookie = value

Cookie.Options.document.__defineGetter__ 'cookie', -> cookie

assert.cookie = (value)->
  assert.equal cookie, value

describe "Cookie", module,

  "#set(name, value)":
    "should set a simple name-value pairs": ->
      Cookie.set('name', 'value')
      assert.cookie 'name=value'

    "should escape any special symbols in the cookie names": ->
      Cookie.set('s{p[e[c]]}', 'value')
      assert.cookie 's%7Bp%5Be%5Bc%5D%5D%7D=value'

    "should convert to JSON any values": ->
      Cookie.set('name', [1,2])
      assert.cookie 'name=%5B1%2C2%5D'

      Cookie.set 'name', {a: 'b'}
      assert.cookie 'name=%7B%22a%22%3A%22b%22%7D'

      date = new Date()
      Cookie.set 'name', date
      assert.cookie "name=#{encodeURIComponent(JSON.stringify(date))}"


  "#set(name, value, options)":
    "should add 'domain' when specified": ->
      Cookie.set('name', 1, {domain: 'boo.hoo'})
      assert.cookie 'name=1; domain=boo.hoo'

    "should add 'path' when specified": ->
      Cookie.set('name', 2, {path: '/url'})
      assert.cookie 'name=2; path=/url'

    "should add 'secure' marker when specified": ->
      Cookie.set('name', 3, {secure: true})
      assert.cookie 'name=3; secure'

    "should add the expiration date when a ttl is specified": ->
      Cookie.set('name', 4, {ttl: 4})
      date = new Date()
      date.setTime(date.getTime() + 4 * 24 * 60 * 60 * 1000)
      assert.cookie "name=4; expires=#{date.toGMTString()}"


  "#get(name)":
    "should return 'undefined' when a cookie wasn't set":->
      cookie = ''
      assert.isUndefined Cookie.get('name')

    "should find simple cooke among others": ->
      cookie = 'name=1;other=2'
      assert.equal Cookie.get('name'), 1

    "should return strings for strings": ->
      cookie = 'name=Nikolay'
      assert.equal Cookie.get('name'), 'Nikolay'

    "should parse JSON saved data": ->
      Cookie.set('name', [1,2,3])
      assert.deepEqual Cookie.get('name'), [1,2,3]

      Cookie.set('name', {a: 'b'})
      assert.deepEqual Cookie.get('name'), {a: 'b'}


  "#remove(name)":
    "should set an empty cookie with yesterday's expiration date":->
      Cookie.set('name', 'value')
      assert.cookie 'name=value'

      Cookie.remove('name')
      date = new Date()
      date.setTime(date.getTime() - 24 * 60 * 60 * 1000)
      assert.cookie "name=; expires=#{date.toGMTString()}"

    "should not touch anything if a cookie wasn't set in the first place": ->
      cookie = ''

      Cookie.remove('name')
      assert.cookie ''


  "#enabled()":
    "should return 'true' when cookies are enabled":->
      assert.isTrue Cookie.enabled()
