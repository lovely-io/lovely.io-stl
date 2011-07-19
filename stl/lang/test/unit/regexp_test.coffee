#
# The RegExp extensions unit tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

describe "Math extensions", module,
  ".escape(string)}":
    "should escape all the special symbols in the string": ->
      assert.equal(
        "\\.\\*\\+\\?\\^\\=\\!\\:\\$\\{\\}\\(\\)\\|\\[\\]\\/\\\\",
        RegExp.escape(".*+?^=!:${}()|[]/\\"))