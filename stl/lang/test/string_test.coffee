#
# The string extensions unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
Lovely = require('lovely')
{Test, assert} = Lovely

eval(Test.build(module))


describe "String extensions", ->
  describe "#empty()", ->
    it "should  return 'true' for an empty string", ->
      assert.isTrue "".empty()
    it "should  return 'false' for non-empty string", ->
      assert.isFalse "boo".empty()
    it "should  return 'false' for a string with blanks only", ->
      assert.isFalse " ".empty()


  describe "#blank()", ->
    it "should  return 'true' for an empty string", ->
      assert.isTrue "".blank()
    it "should  return 'true' for a string with blanks only", ->
      assert.isTrue " \n\t".blank()
    it "should  return 'false' for a non-blank string", ->
      assert.isFalse " boo ".blank()


  describe "#trim()", ->
    it "should  remove staring an ending spaces", ->
      assert.equal "  boo  ".trim(), "boo"

    it "should  leave a string as is if there are no trailing spaces", ->
      assert.equal "boo".trim(), "boo"


  describe "#stripTags()", ->
    it "should  remove all the tags out of the string", ->
      assert.equal "<b>boo</b> hoo<hr/>".stripTags(), "boo hoo"


  describe "#camelize()", ->
    it "should  convert an underscored string into a camelcased one", ->
      assert.equal "_boo_hoo".camelize(), "BooHoo"
    it "should  convert a dashed string into a camelized one", ->
      assert.equal "-boo-hoo".camelize(), "BooHoo"

  describe "#underscored()", ->
    it "should  convert a camelcazed string into an underscored one", ->
      assert.equal "BooHoo".underscored(), "_boo_hoo"

    it "should  convert a dashed string into an underscored one", ->
      assert.equal "-boo-hoo".underscored(), "_boo_hoo"

  describe "#dasherize()", ->
    it "should  convert a camelized string into a dashed one", ->
      assert.equal "BooHoo".dasherize(), "-boo-hoo"
    it "should  convert underscores into dashes", ->
      assert.equal "_boo_hoo".dasherize(), "-boo-hoo"


  describe "#includes(substring)", ->
    it "should  return 'true' if a string includes a substring", ->
      assert.isTrue "super-duper".includes('super')
      assert.isTrue "super-duper".includes('duper')
      assert.isTrue "super-duper".includes('er-du')

    it "should  return 'false' if a string doesn't include given substring", ->
      assert.isFalse "super-duper".includes("uber")


  describe "#endsWith(substring)", ->
    it "should  return 'true' when the string ends with a substring", ->
      assert.isTrue "super-duper".endsWith("duper")

    it "should  return 'false' when the string doesn't end with a substring", ->
      assert.isFalse "super-duper".endsWith("super")

  describe "#startsWith(substring)", ->
    it "should  return 'true' when the string starts with a substring", ->
      assert.isTrue "super-duper".startsWith("super")

    it "should  return 'false' when the string doesn't starts with a substring", ->
      assert.isFalse "super-duper".startsWith("duper")


  describe "#toInt()", ->
    it "should  convert a string into a number", ->
      assert.strictEqual "123".toInt(), 123

    it "should  convert a string into an integer with a custom base", ->
      assert.strictEqual "ff".toInt(16), 255

    it "should  return NaN for an inconvertible strings", ->
      assert.ok isNaN("asdf".toInt())

  describe "#toFloat()", ->
    it "should  convert a string into a float number", ->
      assert.strictEqual "12.3".toFloat(), 12.3

    it "should  return NaN for an inconvertible strings", ->
      assert.ok isNaN("asdf".toFloat())
