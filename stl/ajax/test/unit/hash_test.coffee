#
# The `Hash` unit extensions test
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, load, server} = require("../test_helper")

server.get '/ajax-hash.html', (req, resp)->
  resp.send """
  <html>
    <head>
      <script src="/core.js"></script>
      <script src="/ajax.js"></script>
    </head>
  </html>
  """

Hash = ->
  load "/ajax-hash.html", this, ->
    this.Lovely.Hash


describe "Hash extensions", module,

  ".fromQueryString('data')":
    topic: Hash

    "should parse out data from query strings": (Hash)->
      data = Hash.fromQueryString('some=data&another=value')
      assert.deepEqual data, some: 'data', another: 'value'

    "should return an empty hash for an empty string": (Hash)->
      assert.deepEqual Hash.fromQueryString(''), {}

    "should return an empty hash for 'null' and 'undefined'": (Hash)->
      assert.deepEqual Hash.fromQueryString(null), {}

    "should return an empty hash for a malformed string": (Hash)->
      assert.deepEqual Hash.fromQueryString('malformed-data'), {}

    "should parse array values": (Hash)->
      data = Hash.fromQueryString('key[]=1&key[]=2&key[]=3')
      assert.deepEqual data, key: ['1', '2', '3']

    "should parse hash values": (Hash)->
      data = Hash.fromQueryString('key[a]=a&key[b]=b&key[c]=c')
      assert.deepEqual data, key: {a: 'a', b: 'b', c: 'c'}

  ".toQueryString(object)":
    topic: Hash

    "should convert simple object into a query string": (Hash)->
      str = Hash.toQueryString(a: 'a', b: 'b')
      assert.equal str, 'a=a&b=b'

    "should uri-encode keys and values": (Hash)->
      str = Hash.toQueryString('a$a': 'b$b')
      assert.equal str, 'a%24a=b%24b'

    "should convert arrays into query strings": (Hash)->
      str = Hash.toQueryString(a: [1,2,3])
      assert.equal str, 'a%5B%5D=1&a%5B%5D=2&a%5B%5D=3'

    "should preserve the '[]' in keys for arrays": (Hash)->
      str = Hash.toQueryString('a[]': [1,2,3])
      assert.equal str, 'a%5B%5D=1&a%5B%5D=2&a%5B%5D=3'

    "should convert nested hashes correctly": (Hash)->
      str = Hash.toQueryString(key: a: 1, b: 2, c: 3)
      assert.equal str, 'key%5Ba%5D=1&key%5Bb%5D=2&key%5Bc%5D=3'

