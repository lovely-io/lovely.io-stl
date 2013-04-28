#
# The i18n test
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test, assert} = require('lovely')


describe "Dates i18n", ->

  Date     = null
  date     = null
  original = null
  russian  =
    days:        'Воскресенье Понедельник Вторник Среда Четверг Пятница Суббота'
    daysShort:   'Вск Пнд Втр Срд Чтв Птн Суб'
    months:      'Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'
    monthsShort: 'Янв Фев Мар Апр Май Инь Иль Авг Сен Окт Ноя Дек'


  before Test.load module, (obj)->
    Date = obj

    original = Date.i18n

    date = new Date()
    date.setFullYear(2011)
    date.setMonth(7)
    date.setDate(18)


  describe "dates formatting", ->
    it "should internationalize %a", ->
      Date.i18n = russian
      assert.equal date.format("%a"), "Чтв"
      Date.i18n = original

    it "should internationalize %A", ->
      Date.i18n = russian
      assert.equal date.format("%A"), "Четверг"
      Date.i18n = original

    it "should internationalize %b", ->
      Date.i18n = russian
      assert.equal date.format("%b"), "Авг"
      Date.i18n = original

    it "should internationalize %B", ->
      Date.i18n = russian
      assert.equal date.format("%B"), "Август"
      Date.i18n = original


  describe "dates parsing", ->
    it "should parse %b", ->
      Date.i18n = russian
      assert.equal Date.parse("Авг", "%b").getMonth(), 7
      Date.i18n = original

    it "should parse %B", ->
      Date.i18n = russian
      assert.equal Date.parse("Сентябрь", "%B").getMonth(), 8
      Date.i18n = original
