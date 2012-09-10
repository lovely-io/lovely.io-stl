#
# The 'Ajax' unit test
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
{Test, assert} = require('../../../../cli/lovely')

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

describe "Ajax", ->
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

  get = (callback)->
    Test.load module, "/ajax.html", (Ajax, window)->
      window.XMLHttpRequest = FakeRequest
      callback(Ajax, window.Lovely.module('dom'), window)

  test = (callback)->
    Test.load module, "/ajax.html", (Ajax, window)->
      window.XMLHttpRequest = FakeRequest
      callback(new Ajax('/ajax-text.html', method: 'get'), Ajax, window.Lovely.module('dom'), window)


  describe "\b#constructor", ->

    it "should create an instance of Ajax", get (Ajax)->
      assert.instanceOf new Ajax(), Ajax

    it "should assign the 'url' attribute", get (Ajax)->
      ajax = new Ajax('/some.url')
      assert.same ajax.url, '/some.url'

    it "should merge the global and local attributes", get (Ajax, $, window)->
      options =
        method:   'get'
        encoding: 'cp1251'

      ajax = new Ajax('/some.url', options)

      assert.deepEqual ajax.options, window.Lovely.Hash.merge(Ajax.Options, options)

    it "should accept the event callbacks with the options", get (Ajax)->
      call1 = ->
      call2 = ->

      ajax = new Ajax('/some.url', success: call1, failure: call2)

      assert.isTrue ajax.ones('success', call1)
      assert.isTrue ajax.ones('failure', call2)

  describe "\b#header", ->

    describe "\b('name')", ->

      it "should return a response header value", test (ajax)->
        ajax._ = getResponseHeader: (key)->
          "header data" if key is "the-key"
        assert.equal ajax.header("the-key"), "header data"

      it "should return 'undefined' if there is no request", test (ajax)->
        ajax._ = null
        assert.isUndefined ajax.header("the-key")

    describe "\b('name', 'value')", ->

      it "should assign the header to be sent with the request", test (ajax)->
        ajax.header('my-header', 'my-data')
        assert.equal ajax.options.headers['my-header'], 'my-data'

      it "should return the ajax request itself back to the code", test (ajax)->
        assert.same ajax.header('my-header', 'my-value'), ajax

  describe "\b#successful()", ->

    it "should say 'true' if the request is successful", test (ajax)->
      ajax.status = 200
      assert.isTrue ajax.successful()
      ajax.status = 302
      assert.isTrue ajax.successful()

    it "should say 'false' if the request had failed", test (ajax)->
      ajax.status = 0
      assert.isFalse ajax.successful()

      ajax.status = 404
      assert.isFalse ajax.successful()

  describe "\b#cancel()", ->

    it "should call 'abort' on the XHR object", test (ajax)->
      called = false
      ajax._ = abort: -> called = true

      ajax.cancel()

      assert.isTrue called

    it "should emit the 'cancel' event", test (ajax)->
      ajax.__canceled = false

      called = false
      ajax.on 'cancel', -> called = true

      ajax.cancel()

      assert.isTrue called

  describe "\b#emit('event-name')", ->

    it "should allow to emit events", test (ajax)->
      called = false
      ajax.on 'something', -> called = true
      ajax.emit('something')

      assert.isTrue called

    it "should emit an 'ajax:event-name' event on current document", test (ajax, Ajax, $, window)->
      called = false
      event  = null

      $(window.document).on('ajax:test', (e)-> event = e; called = true)

      ajax.emit('test')

      assert.isTrue called
      assert.same   event.ajax, ajax

    it "should return the request object back to the code", test (ajax)->
      assert.same ajax.emit('stuff'), ajax


  describe "\b#send()", ->

    it "should accept 'put' and 'delete' methods", test (ajax)->
      for method in ['put', 'delete']
        ajax.options.method = method
        ajax.send()
        assert.equal ajax._.method, "post"
        assert.equal ajax._.params, "_method=#{method}"

      ajax.options.method = 'post'

    it "should add the url-encoded header for url-encoded data", test (ajax)->
      ajax.options.params = 'a$a=b$b'
      ajax.options.method = 'post'
      ajax.send()

      assert.equal ajax._.params, 'a%24a=b%24b'

    it "should add the url-encoded data to the URL on a GET request", test (ajax)->
      ajax.options.params = 'a$a=b$b'
      ajax.send()

      assert.equal ajax._.url, '/ajax-text.html?a%24a=b%24b'

    it "should assign all the headers to the XHR object", test (ajax)->
      ajax.options.headers = one: 'first', two: 'second'
      ajax.send()
      assert.equal ajax._.header.one, 'first'
      assert.equal ajax._.header.two, 'second'

    it "should use XMLHttpRequest tunnel by default", test (ajax)->
      ajax.send()
      assert.instanceOf ajax._, FakeRequest

    it "should emit 'create' event before sending the request", test (ajax)->
      request = null
      opened  = null
      ajax.on('create', -> request = @_; opened = !!@_.method)

      ajax.send()

      assert.isNotNull request
      assert.isFalse   opened

    it.only "should emit 'request' event after sending the request", test (ajax)->
      sent = null
      ajax.on('request', -> sent = true)
      ajax.send()

      assert.isTrue sent

    it "should return the request object itself back to the code", test (ajax)->
      assert.same ajax.send(), ajax



  describe "params processing", ->

    it "should send the global params", get (Ajax)->
      Ajax.Options.params = 'global=params'
      ajax = new Ajax()
      ajax.send()
      assert.equal ajax._.params, 'global=params'

    it "should send the options params", get (Ajax)->
      Ajax.Options.params = null
      ajax = new Ajax('/some.url', params: 'local=params')
      ajax.send()
      assert.equal ajax._.params, 'local=params'

    it "should extract and send Form values", get (Ajax, $)->
      form = new $.Form(action: '/boo')
      ajax = new Ajax('/some.url', params: form)

      form.values = -> name1: 'value1', name2: 'value2'
      ajax.send()

      assert.equal ajax._.params, 'name1=value1&name2=value2'

    it "should merge global and options params", get (Ajax)->
      Ajax.Options.params = 'global=params'
      ajax = new Ajax('/some.url', params: local: 'data')

      ajax.send()

      assert.equal ajax._.params, 'global=params&local=data'


    it "should set the GET request params into the url", get (Ajax)->
      Ajax.Options.params = null
      ajax = new Ajax('/some.url', method: 'get', params: 'some=data')
      ajax.send()

      assert.equal ajax._.url, '/some.url?some=data'



  describe "auto-handling text/javascript an text/json responses", ->

    it "should automatically eval the text/javascript responses in the global context", test (ajax, Ajax, $, window)->
      ajax.header = (name)-> 'text/javascript' if name is 'Content-type'
      ajax.responseText = "var test1='text/javascript test';"

      ajax.emit('complete')

      assert.equal window.test1, 'text/javascript test'

    it "should automatically parse the text/json responses", test (ajax)->
      ajax.header = (name)-> 'text/json' if name is 'Content-type'
      ajax.responseText = '{"some": "value"}'

      ajax.emit('complete')

      assert.deepEqual ajax.responseJSON, some: 'value'

    it "should throw an error on a malformed json data", test (ajax)->
      ajax.header = (name)-> 'text/json' if name is 'Content-type'
      ajax.responseText = "malformed data"

      try
        ajax.emit('complete')
        assert.isTrue false
      catch e
        assert.isTrue true

    it "should extract data from the X-JSON header", test (ajax)->
      ajax.header = (name)-> '{"header": "data"}' if name is 'X-JSON'
      ajax.responseText = 'some text'
      ajax.emit('complete')
      assert.deepEqual ajax.headerJSON, header: 'data'




  describe "spinners handling", ->

    it "should show the spinner when a request is created", get (Ajax, $)->
      spinner = $('#spinner')[0].hide()

      ajax = new Ajax('/some.url', spinner: '#spinner')
      ajax.emit('create')

      assert.isTrue spinner.visible()


    it "should hide the spinner when a request is complete", get (Ajax, $)->
      spinner = $('#spinner')[0].show()

      ajax = new Ajax('/some.url', spinner: '#spinner')
      ajax.emit('complete')

      assert.isTrue spinner.hidden()

    it "should hide the spinner when a request is canceled", get (Ajax, $)->
      spinner = $('#spinner')[0].show()

      ajax = new Ajax('/some.url', spinner: '#spinner')
      ajax.emit('cancel')

      assert.isTrue spinner.hidden()

    it "should not hide a global spinner until all requests are finished", get (Ajax, $, window)->
      spinner = $('#spinner')[0].hide()
      Ajax.Options.spinner = '#spinner'

      ajax1 = new Ajax('/some.url')
      ajax2 = new Ajax('/some.url')

      ajax1.emit('create')
      ajax2.emit('create')

      assert.isTrue spinner.visible()

      ajax1.emit('complete')
      assert.isTrue spinner.visible()

      ajax2.emit('complete')
      assert.isFalse spinner.visible()






