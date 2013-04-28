#
# The 'Ajax' unit test
#
# Copyright (C) 2011-2013 Nikolay Nemshilov
#
{Test, should} = require('lovely')

Test.set
  '/ajax.html': """
    <html>
      <head>
        <script src="/core.js"></script>
        <script src="/ajax.js"></script>
      </head>
      <body>
        <div id="spinner"></div>
      </body>
    </html>
  """

  '/ajax-text.html': """
    <div>ajax-text</div>
  """

# faking the request to be able to test headers correctly
class FakeRequest
  setRequestHeader: (name, value)->
    @header or= {}
    @header[name] = value

  open: (method, url, async)->
    @method = method
    @url    = url
    @async  = async

  send: (params)->
    @params = params

describe "Ajax", ->
  Ajax = ajax = window = document = $ = null

  before Test.load "/ajax.html", (mod, win)->
    Ajax   = mod
    window = win
    window.XMLHttpRequest = FakeRequest
    ajax   = new Ajax('/ajax-text.html')
    $      = window.Lovely.module('dom')

  describe "\b#constructor", ->

    it "should create an instance of Ajax", ->
      new Ajax().should.be.instanceof Ajax

    it "should assign the 'url' attribute", ->
      a = new Ajax('/some.url')
      a.url.should.eql '/some.url'

    it "should merge the global and local attributes", ->
      options = method: 'get', encoding: 'cp1251'

      a = new Ajax('/some.url', options)

      a.options.should.eql window.Lovely.Hash.merge(Ajax.Options, options)

    it "should accept the event callbacks with the options", ->
      call1 = ->
      call2 = ->

      a = new Ajax('/some.url', success: call1, failure: call2)

      a.ones('success', call1).should.be.true
      a.ones('failure', call2).should.be.true

  describe "\b#header", ->

    describe "\b('name')", ->

      it "should return a response header value", ->
        ajax._ = getResponseHeader: (key)->
          "header data" if key is "the-key"
        ajax.header("the-key").should.eql "header data"

      it "should return 'undefined' if there is no request", ->
        ajax._ = null
        (ajax.header("the-key") is undefined).should.be.true

    describe "\b('name', 'value')", ->

      it "should assign the header to be sent with the request", ->
        ajax.header('my-header', 'my-data')
        ajax.options.headers['my-header'].should.equal 'my-data'

      it "should return the ajax request itself back to the code", ->
        ajax.header('my-header', 'my-value').should.equal ajax


  describe "\b#successful()", ->

    it "should say 'true' if the request is successful", ->
      ajax.status = 200
      ajax.successful().should.be.true
      ajax.status = 302
      ajax.successful().should.be.true

    it "should say 'false' if the request had failed", ->
      ajax.status = 0
      ajax.successful().should.be.false

      ajax.status = 404
      ajax.successful().should.be.false

  describe "\b#cancel()", ->

    it "should call 'abort' on the XHR object", ->
      called = false
      ajax._ = abort: -> called = true

      ajax.cancel()

      called.should.be.true

    it "should emit the 'cancel' event", ->
      ajax.__canceled = false

      called = false
      ajax.on 'cancel', -> called = true

      ajax.cancel()

      called.should.be.true

  describe "\b#emit('event-name')", ->

    it "should allow to emit events", ->
      called = false
      ajax.on 'something', -> called = true
      ajax.emit('something')

      called.should.be.true

    it "should emit an 'ajax:event-name' event on current document", ->
      called = false
      event  = null

      $(window.document).on('ajax:test', (e)-> event = e; called = true)

      ajax.emit('test')

      called.should.be.true
      event.ajax.should.equal ajax

    it "should return the request object back to the code", ->
      ajax.emit('stuff').should.equal ajax


  describe "\b#send()", ->

    it "should accept 'put' and 'delete' methods", ->
      for method in ['put', 'delete']
        ajax.options.method = method
        ajax.send()
        ajax._.method.should.eql "post"
        ajax._.params.should.eql "_method=#{method}"

    it "should add the url-encoded header for url-encoded data", ->
      ajax.options.params = 'a$a=b$b'
      ajax.options.method = 'post'
      ajax.send()

      ajax._.params.should.equal 'a%24a=b%24b'

    it "should add the url-encoded data to the URL on a GET request", ->
      ajax.options.params = 'a$a=b$b'
      ajax.options.method = 'get'
      ajax.send()

      ajax._.url.should.equal '/ajax-text.html?a%24a=b%24b'

    it "should assign all the headers to the XHR object", ->
      ajax.options.headers = one: 'first', two: 'second'
      ajax.send()
      ajax._.header.one.should.equal 'first'
      ajax._.header.two.should.equal 'second'

    it "should use XMLHttpRequest tunnel by default", ->
      ajax.send()
      ajax._.should.be.instanceof window.XMLHttpRequest

    it "should emit 'create' event before sending the request", ->
      request = null
      opened  = null
      ajax.on('create', -> request = @_; opened = !!@_.method)

      ajax.send()

      request.should.not.be.null
      opened.should.be.false

    it "should emit 'request' event after sending the request", ->
      sent = null
      ajax.on('request', -> sent = true)
      ajax.send()

      sent.should.be.true

    it "should return the request object itself back to the code", ->
      ajax.send().should.equal ajax



  describe "params processing", ->

    it "should send the global params", ->
      Ajax.Options.params = 'global=params'
      a = new Ajax().send()
      a._.params.should.equal 'global=params'

    it "should send the options params", ->
      Ajax.Options.params = null
      a = new Ajax('/some.url', params: 'local=params').send()
      a._.params.should.equal 'local=params'

    it "should extract and send Form values", ->
      form = new $.Form(action: '/boo')
      form.values = -> name1: 'value1', name2: 'value2'

      a    = new Ajax('/some.url', params: form).send()

      a._.params.should.equal 'name1=value1&name2=value2'

    it "should merge global and options params", ->
      Ajax.Options.params = 'global=params'
      a = new Ajax('/some.url', params: local: 'data').send()

      a._.params.should.eql 'global=params&local=data'


    it "should set the GET request params into the url", ->
      Ajax.Options.params = null
      a = new Ajax('/some.url', method: 'get', params: 'some=data').send()

      a._.url.should.equal '/some.url?some=data'



  describe "auto-handling text/javascript an text/json responses", ->

    it "should automatically eval the text/javascript responses in the global context", ->
      ajax.header = (name)-> 'text/javascript' if name is 'Content-type'
      ajax.responseText = "var test1='text/javascript test';"

      ajax.emit('complete')

      window.test1.should.equal 'text/javascript test'

    it "should automatically parse the text/json responses", ->
      ajax.header = (name)-> 'text/json' if name is 'Content-type'
      ajax.responseText = '{"some": "value"}'

      ajax.emit('complete')

      ajax.responseJSON.should.eql some: 'value'

    it "should throw an error on a malformed json data", ->
      ajax.header = (name)-> 'text/json' if name is 'Content-type'
      ajax.responseText = "malformed data"

      try
        ajax.emit('complete')
        false.shoul.de.true # failing
      catch e


    it "should extract data from the X-JSON header", ->
      ajax.header = (name)-> '{"header": "data"}' if name is 'X-JSON'
      ajax.responseText = 'some text'
      ajax.emit('complete')
      ajax.headerJSON.should.eql header: 'data'




  describe "spinners handling", ->

    it "should show the spinner when a request is created", ->


      spinner = $('#spinner')[0].hide()

      a = new Ajax('/some.url', spinner: '#spinner')
      a.emit('create')

      spinner.visible().should.be.true


    it "should hide the spinner when a request is complete", ->
      spinner = $('#spinner')[0].show()

      a = new Ajax('/some.url', spinner: '#spinner')
      a.emit('complete')

      spinner.hidden().should.be.true


    it "should hide the spinner when a request is canceled", ->
      spinner = $('#spinner')[0].show()

      a = new Ajax('/some.url', spinner: '#spinner')
      a.emit('cancel')

      spinner.hidden().should.be.true


    it "should not hide a global spinner until all requests are finished", ->
      spinner = $('#spinner')[0].hide()
      Ajax.Options.spinner = '#spinner'

      ajax1 = new Ajax('/some.url')
      ajax2 = new Ajax('/some.url')

      ajax1.emit('create')
      ajax2.emit('create')

      spinner.visible().should.be.true

      ajax1.emit('complete')
      spinner.visible().should.be.true

      ajax2.emit('complete')
      spinner.visible().should.be.false


