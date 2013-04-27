#
# The `Hash` unit extensions test
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test, should} = require('lovely')


describe "Hash extensions", ->
  Hash = null

  before Test.load module, (Ajax, window)->
    Hash = window.Lovely.Hash

  describe ".fromQueryString('data')", ->

    it "should parse out data from query strings", ->
      data = Hash.fromQueryString('some=data&another=value')
      data.should.eql some: 'data', another: 'value'

    it "should return an empty hash for an empty string", ->
      Hash.fromQueryString('').should.eql {}

    it "should return an empty hash for 'null' and 'undefined'", ->
      Hash.fromQueryString(null).should.eql {}

    it "should return an empty hash for a malformed string", ->
      Hash.fromQueryString('malformed-data').should.eql {}

    it "should parse array values", ->
      data = Hash.fromQueryString('key[]=1&key[]=2&key[]=3')
      data.should.eql key: ['1', '2', '3']

    it "should parse hash values", ->
      data = Hash.fromQueryString('key[a]=a&key[b]=b&key[c]=c')
      data.should.eql key: {a: 'a', b: 'b', c: 'c'}

  describe ".toQueryString(object)", ->

    it "should convert simple object into a query string", ->
      str = Hash.toQueryString(a: 'a', b: 'b')
      str.should.eql 'a=a&b=b'

    it "should uri-encode keys and values", ->
      str = Hash.toQueryString('a$a': 'b$b')
      str.should.eql 'a%24a=b%24b'

    it "should convert arrays into query strings", ->
      str = Hash.toQueryString(a: [1,2,3])
      str.should.eql 'a%5B%5D=1&a%5B%5D=2&a%5B%5D=3'

    it "should preserve the '[]' in keys for arrays", ->
      str = Hash.toQueryString('a[]': [1,2,3])
      str.should.eql 'a%5B%5D=1&a%5B%5D=2&a%5B%5D=3'

    it "should convert nested hashes correctly", ->
      str = Hash.toQueryString(key: a: 1, b: 2, c: 3)
      str.should.eql 'key%5Ba%5D=1&key%5Bb%5D=2&key%5Bc%5D=3'

