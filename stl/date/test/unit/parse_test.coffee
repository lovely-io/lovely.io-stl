#
# The Date.parse method extension tests
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert} = require('../test_helper')

describe "Date.parse", module,

  "year parsing":
    "it should parse %Y": ->
      assert.equal Date.parse("2011", "%Y").getFullYear(), 2011

    "it should parse %y": ->
      assert.equal Date.parse("78", "%y").getFullYear(), 1978

  "months parsing":
    "it should parse %b": ->
      assert.equal Date.parse("Aug", "%b").getMonth(), 7

    "it should parse %B": ->
      assert.equal Date.parse("September", "%B").getMonth(), 8

    "it should parse %m": ->
      assert.equal Date.parse("08", "%m").getMonth(), 7

  "dates parsing":
    "it should parse %d": ->
      assert.equal Date.parse("18", "%d").getDate(), 18

    "it should parse %e": ->
      assert.equal Date.parse("8", "%e").getDate(), 8

  "time parsing":
    "it should understand %H": ->
      assert.equal Date.parse("16", "%H").getHours(), 16

    "it should understand %k": ->
      assert.equal Date.parse("8", "%k").getHours(), 8

    "it should understand %I + %P": ->
      assert.equal Date.parse("8PM", "%I%p").getHours(), 20
      assert.equal Date.parse("8AM", "%I%p").getHours(), 8

    "it should understand %l + %p": ->
      assert.equal Date.parse("8pm", "%l%P").getHours(), 20
      assert.equal Date.parse("8am", "%l%P").getHours(), 8

    "it should understand %M": ->
      assert.equal Date.parse("08", "%M").getMinutes(), 8

    "it should understand %S": ->
      assert.equal Date.parse("09", "%S").getSeconds(), 9

  "original method":
    "it should be operational": ->
      date = new Date()
      assert.equal new Date(Date.parse(date.toString())).toString(), date.toString()