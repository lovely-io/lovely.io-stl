#
# The string extensions unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

describe "String extensions", module,
  "#empty()":
    "should return 'true' for an empty string": ->
      assert.isTrue "".empty()
    "should return 'false' for non-empty string": ->
      assert.isFalse "boo".empty()
    "should return 'false' for a string with blanks only":->
      assert.isFalse " ".empty()


  "#blank()":
    "should return 'true' for an empty string": ->
      assert.isTrue "".blank()
    "should return 'true' for a string with blanks only": ->
      assert.isTrue " \n\t".blank()
    "should return 'false' for a non-blank string": ->
      assert.isFalse " boo ".blank()


  "#trim()":
    "should remove staring an ending spaces": ->
      assert.equal "  boo  ".trim(), "boo"

    "should leave a string as is if there are no trailing spaces":->
      assert.equal "boo".trim(), "boo"


  "#stripTags()":
    "should remove all the tags out of the string": ->
      assert.equal "<b>boo</b> hoo<hr/>".stripTags(), "boo hoo"


  "#camelize()":
    "should convert an underscored string into a camelcased one":->
      assert.equal "_boo_hoo".camelize(), "BooHoo"
    "should convert a dashed string into a camelized one":->
      assert.equal "-boo-hoo".camelize(), "BooHoo"

  "#underscored()":
    "should convert a camelcazed string into an underscored one": ->
      assert.equal "BooHoo".underscored(), "_boo_hoo"

    "should convert a dashed string into an underscored one": ->
      assert.equal "-boo-hoo".underscored(), "_boo_hoo"

  "#dasherize()":
    "should convert a camelized string into a dashed one": ->
      assert.equal "BooHoo".dasherize(), "-boo-hoo"
    "should convert underscores into dashes": ->
      assert.equal "_boo_hoo".dasherize(), "-boo-hoo"


  "#includes(substring)":
    "should return 'true' if a string includes a substring": ->
      assert.isTrue "super-duper".includes('super')
      assert.isTrue "super-duper".includes('duper')
      assert.isTrue "super-duper".includes('er-du')

    "should return 'false' if a string doesn't include given substring": ->
      assert.isFalse "super-duper".includes("uber")


  "#endsWith(substring)":
    "should return 'true' when the string ends with a substring": ->
      assert.isTrue "super-duper".endsWith("duper")

    "should return 'false' when the string doesn't end with a substring": ->
      assert.isFalse "super-duper".endsWith("super")

  "#startsWith(substring)":
    "should return 'true' when the string starts with a substring": ->
      assert.isTrue "super-duper".startsWith("super")

    "should return 'false' when the string doesn't starts with a substring": ->
      assert.isFalse "super-duper".startsWith("duper")


  "#toInt()":
    "should convert a string into a number": ->
      assert.same "123".toInt(), 123

    "should convert a string into an integer with a custom base": ->
      assert.same "ff".toInt(16), 255

    "should return NaN for an inconvertible strings": ->
      assert.isNaN "asdf".toInt()

  "#toFloat()":
    "should convert a string into a float number": ->
      assert.same "12.3".toFloat(), 12.3

    "should return NaN for an inconvertible strings": ->
      assert.isNaN "asdf".toFloat()