#
# The `Window` wrapper unit tests
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test} = require('lovely')


describe 'Window', ->
  $ = window = Window = raw_window = null

  before Test.load module, (build, raw_win)->
    $          = build
    Window     = $.Window
    window     = new Window(raw_win)
    raw_window = raw_win


  describe 'constructor', ->

    it "should make an instance of 'Window' class", ->
      window.should.be.instanceOf Window

    it "should refer to the original window via '_'", ->
      window._.should.equal raw_window

  describe 'events handling interface', ->

    it "should copy #on from Element#on", ->
      ($.Window.prototype.on is $.Element.prototype.on).should.be.true

    it "should copy #no from Element#no", ->
      ($.Window.prototype.no is $.Element.prototype.no).should.be.true

    it "should copy #ones from Element#ones", ->
      ($.Window.prototype.ones is $.Element.prototype.ones).should.be.true

    it "should copy #emit from Element#emit", ->
      ($.Window.prototype.emit is $.Element.prototype.emit).should.be.true


  describe '#window', ->

    it "should return itself with this method", ->
      window.window().should.be.same window

  describe '#size', ->

    describe "\b()", ->

      it "should return the window sizes in a hash", ->
        window.size().x.should.eql 1024
        window.size().y.should.eql 768

    describe "\b(x:NNN, y:NNN)", ->

      it "should set the new window inner size", ->
        size_x = []; size_y = []

        window._.resizeTo = (x, y) ->
          size_x.push(x); size_y.push(y)

        window.size x: 800, y: 600

        size_x[0].should.eql 800
        size_y[0].should.eql 600

        size_x[1].should.eql 2 * 800 - 1024
        size_y[1].should.eql 2 * 600 - 768

      it "should return the window object itself back", ->
        window.size(100, 200).should.equal window

  describe "#scrolls", ->
    describe "\b()", ->

      it "should return the current scrolling position", ->
        window.scrolls().x.should.eql 0
        window.scrolls().y.should.eql 0

    describe "\b(x:NNN, y:NNN)", ->

      it "should assign new scrolling position", ->
        pos_x = null; pos_y = null

        window._.scrollTo = (x,y)->
          pos_x = x; pos_y = y

        window.scrolls x: 100, y: 200

        pos_x.should.eql 100
        pos_y.should.eql 200

      it "should accept just one direction", ->
        pos_x = null; pos_y = null

        window._.scrollTo = (x,y)->
          pos_x = x; pos_y = y

        window.scrolls x: 100

        pos_x.should.eql 100
        pos_y.should.eql 0

        window.scrolls y: 200

        pos_x.should.eql 0
        pos_y.should.eql 200

      it "should work with two-number calls", ->
        pos_x = null; pos_y = null

        window._.scrollTo = (x,y)->
          pos_x = x; pos_y = y

        window.scrolls 300, 400

        pos_x.should.eql 300
        pos_y.should.eql 400

      it "should return the window reference back", ->
        window.scrolls(x:100).should.be.same window
