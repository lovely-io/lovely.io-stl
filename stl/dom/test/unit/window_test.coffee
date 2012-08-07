#
# The `Window` wrapper unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Browser} = require('../test_helper')

window = ->
  load "/test.html", this, (dom)->
    new dom.Window(this.window)


describe 'Window', ->
  get = (callback)->
    (done)->
      Browser.open "/test.html", ($, window)->
        callback(new $.Window(window), $, window)
        done()

  describe 'constructor', ->

    it "should make an instance of 'Window' class", get (win, $)->
      win.should.be.instanceOf $.Window

    it "should refer to the original window via '_'", get (win, $, window)->
      win._.should.equal window

  describe 'events handling interface', ->

    it "should copy #on from Element#on", get (win, $)->
      ($.Window.prototype.on is $.Element.prototype.on).should.be.true

    it "should copy #no from Element#no", get (win, $)->
      ($.Window.prototype.no is $.Element.prototype.no).should.be.true

    it "should copy #ones from Element#ones", get (win, $)->
      ($.Window.prototype.ones is $.Element.prototype.ones).should.be.true

    it "should copy #emit from Element#emit", get (win, $)->
      ($.Window.prototype.emit is $.Element.prototype.emit).should.be.true


  describe '#window', ->

    it "should return itself with this method", get (window)->
      window.window().should.be.same window

  describe '#size', ->

    describe "\b()", ->

      it "should return the window sizes in a hash", get (window)->
        window.size().x.should.eql 1024
        window.size().y.should.eql 768

    describe "\b(x:NNN, y:NNN)", ->

      it "should set the new window inner size", get (window)->
        size_x = []; size_y = []

        window._.resizeTo = (x, y) ->
          size_x.push(x); size_y.push(y)

        window.size x: 800, y: 600

        size_x[0].should.eql 800
        size_y[0].should.eql 600

        size_x[1].should.eql 2 * 800 - 1024
        size_y[1].should.eql 2 * 600 - 768

      it "should return the window object itself back", get (window)->
        window.size(100, 200).should.equal window

  describe "#scrolls", ->
    describe "\b()", ->

      it "should return the current scrolling position", get (window)->
        window.scrolls().x.should.eql 0
        window.scrolls().y.should.eql 0

    describe "\b(x:NNN, y:NNN)", ->

      it "should assign new scrolling position", get (window)->
        pos_x = null; pos_y = null

        window._.scrollTo = (x,y)->
          pos_x = x; pos_y = y

        window.scrolls x: 100, y: 200

        pos_x.should.eql 100
        pos_y.should.eql 200

      it "should accept just one direction", get (window)->
        pos_x = null; pos_y = null

        window._.scrollTo = (x,y)->
          pos_x = x; pos_y = y

        window.scrolls x: 100

        pos_x.should.eql 100
        pos_y.should.eql 0

        window.scrolls y: 200

        pos_x.should.eql 0
        pos_y.should.eql 200

      it "should work with two-number calls", get (window) ->
        pos_x = null; pos_y = null

        window._.scrollTo = (x,y)->
          pos_x = x; pos_y = y

        window.scrolls 300, 400

        pos_x.should.eql 300
        pos_y.should.eql 400

      it "should return the window reference back", get (window)->
        window.scrolls(x:100).should.be.same window
