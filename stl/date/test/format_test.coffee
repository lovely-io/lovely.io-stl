#
# Date#format method unit tests
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test, assert} = require('lovely')

describe "Date formatting", ->
  Date = date = null

  before Test.load (build)->
    Date = build
    date = new Date()
    date.setFullYear(2011)
    date.setMonth(7)
    date.setDate(17)
    date.setHours(18)
    date.setMinutes(45)
    date.setSeconds(22)

  describe "year formatting", ->
    it "should understand the %Y key", ->
      assert.equal date.format("%Y"), "2011"

    it "should understand the %y key", ->
      assert.equal date.format("%y"), "11"
      d = new Date()
      d.setFullYear('2008')
      assert.equal d.format("%y"), "08"

  describe "month formatting", ->
    it "should understand the %b key", ->
      assert.equal date.format('%b'), 'Aug'

    it "should understand the %B key", ->
      assert.equal date.format('%B'), 'August'

    it "should understand the %m key", ->
      assert.equal date.format("%m"), "08"

  describe "day formatting", ->
    it "should understand the %a key", ->
      assert.equal date.format("%a"), "Wed"

    it "should understand the %A key", ->
      assert.equal date.format("%A"), "Wednesday"

    it "should understand the %d key", ->
      assert.equal date.format("%d"), "17"
      d = new Date()
      d.setDate(8)
      assert.equal d.format("%d"), "08"

    it "should understand the %e key", ->
      assert.equal date.format("%e"), "17"
      d = new Date()
      d.setDate(8)
      assert.equal d.format("%e"), "8"

  describe "date formatting", ->
    it "should understand the %H key", ->
      assert.equal date.format("%H"), "18"
      d = new Date()
      d.setHours(8)
      assert.equal d.format("%H"), "08"

    it "should understand the %k key", ->
      assert.equal date.format("%k"), "18"
      d = new Date()
      d.setHours(8)
      assert.equal d.format("%k"), "8"

    it "should understand the %I key", ->
      assert.equal date.format("%I"), "06"

    it "should understand the %l key", ->
      assert.equal date.format("%l"), "6"

    it "should understand the %p key", ->
      assert.equal date.format("%p"), "PM"

    it "should understand the %P key", ->
      assert.equal date.format("%P"), "pm"

    it "should understand the %M key", ->
      assert.equal date.format("%M"), "45"
      d = new Date()
      d.setMinutes(8)
      assert.equal d.format("%M"), "08"

    it "should understand the %S key", ->
      assert.equal date.format("%S"), "22"

    it "should convert the %% key", ->
      assert.equal date.format("%%"), "%"


