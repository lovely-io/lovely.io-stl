#
# Date#format method unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test, assert} = require('../../../../cli/lovely')

describe "Date formatting", ->
  Date = null
  date = null

  before Test.load(module, (obj)->
    Date = obj
    date = new Date()
    date.setFullYear(2011)
    date.setMonth(7)
    date.setDate(17)
    date.setHours(18)
    date.setMinutes(45)
    date.setSeconds(22)
  )


  describe "year formatting", ->
    it "should understand the %Y key", ->
      assert.same date.format("%Y"), "2011"

    it "should understand the %y key", ->
      assert.same date.format("%y"), "11"
      d = new Date()
      d.setFullYear('2008')
      assert.same d.format("%y"), "08"

  describe "month formatting", ->
    it "should understand the %b key", ->
      assert.same date.format('%b'), 'Aug'

    it "should understand the %B key", ->
      assert.same date.format('%B'), 'August'

    it "should understand the %m key", ->
      assert.same date.format("%m"), "08"

  describe "day formatting", ->
    it "should understand the %a key", ->
      assert.same date.format("%a"), "Wed"

    it "should understand the %A key", ->
      assert.same date.format("%A"), "Wednesday"

    it "should understand the %d key", ->
      assert.same date.format("%d"), "17"
      d = new Date()
      d.setDate(8)
      assert.same d.format("%d"), "08"

    it "should understand the %e key", ->
      assert.same date.format("%e"), "17"
      d = new Date()
      d.setDate(8)
      assert.same d.format("%e"), "8"

  describe "date formatting", ->
    it "should understand the %H key", ->
      assert.same date.format("%H"), "18"
      d = new Date()
      d.setHours(8)
      assert.same d.format("%H"), "08"

    it "should understand the %k key", ->
      assert.same date.format("%k"), "18"
      d = new Date()
      d.setHours(8)
      assert.same d.format("%k"), "8"

    it "should understand the %I key", ->
      assert.same date.format("%I"), "06"

    it "should understand the %l key", ->
      assert.same date.format("%l"), "6"

    it "should understand the %p key", ->
      assert.same date.format("%p"), "PM"

    it "should understand the %P key", ->
      assert.same date.format("%P"), "pm"

    it "should understand the %M key", ->
      assert.same date.format("%M"), "45"
      d = new Date()
      d.setMinutes(8)
      assert.same d.format("%M"), "08"

    it "should understand the %S key", ->
      assert.same date.format("%S"), "22"

    it "should convert the %% key", ->
      assert.same date.format("%%"), "%"


