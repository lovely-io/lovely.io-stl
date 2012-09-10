#
# The `Hash` unit extensions test
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test, assert} = require('../../../../cli/lovely')


describe "Hash extensions",
  get = (callback)->
    Test.load module, (Ajax, window)->
      window.Lovely.Hash

  describe ".fromQueryString('data')", ->

    it "should parse out data from query strings", get (Hash)->
      data = Hash.fromQueryString('some=data&another=value')
      assert.deepEqual data, some: 'data', another: 'value'

    it "should return an empty hash for an empty string", get (Hash)->
      assert.deepEqual Hash.fromQueryString(''), {}

    it "should return an empty hash for 'null' and 'undefined'", get (Hash)->
      assert.deepEqual Hash.fromQueryString(null), {}

    it "should return an empty hash for a malformed string", get (Hash)->
      assert.deepEqual Hash.fromQueryString('malformed-data'), {}

    it "should parse array values", get (Hash)->
      data = Hash.fromQueryString('key[]=1&key[]=2&key[]=3')
      assert.deepEqual data, key: ['1', '2', '3']

    it "should parse hash values", get (Hash)->
      data = Hash.fromQueryString('key[a]=a&key[b]=b&key[c]=c')
      assert.deepEqual data, key: {a: 'a', b: 'b', c: 'c'}

  describe ".toQueryString(object)", ->

    it "should convert simple object into a query string", get (Hash)->
      str = Hash.toQueryString(a: 'a', b: 'b')
      assert.equal str, 'a=a&b=b'

    it "should uri-encode keys and values", get (Hash)->
      str = Hash.toQueryString('a$a': 'b$b')
      assert.equal str, 'a%24a=b%24b'

    it "should convert arrays into query strings", get (Hash)->
      str = Hash.toQueryString(a: [1,2,3])
      assert.equal str, 'a%5B%5D=1&a%5B%5D=2&a%5B%5D=3'

    it "should preserve the '[]' in keys for arrays", get (Hash)->
      str = Hash.toQueryString('a[]': [1,2,3])
      assert.equal str, 'a%5B%5D=1&a%5B%5D=2&a%5B%5D=3'

    it "should convert nested hashes correctly", get (Hash)->
      str = Hash.toQueryString(key: a: 1, b: 2, c: 3)
      assert.equal str, 'key%5Ba%5D=1&key%5Bb%5D=2&key%5Bc%5D=3'

