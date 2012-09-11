#
# The RegExp extensions unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
Lovely = require('../../../../cli/lovely')
{Test, assert} = Lovely

eval(Test.build(module))


describe "Math extensions", ->
  describe ".escape(string)}", ->
    it "should escape all the special symbols in the string", ->
      assert.equal(
        "\\.\\*\\+\\?\\^\\=\\!\\:\\$\\{\\}\\(\\)\\|\\[\\]\\/\\\\",
        RegExp.escape(".*+?^=!:${}()|[]/\\"))