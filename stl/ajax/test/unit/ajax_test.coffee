#
# The 'Ajax' unit test
#
# Copyright (C) 2011 Nikolay Nemshilov
#
{describe, assert, server, load} = require('../test_helper')

server.respond
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

Ajax = ->
  load "/ajax.html", this, (Ajax)->
    this.window.XMLHttpRequest = FakeRequest
    Ajax

test_request = ->
  load "/ajax.html", this, (Ajax)->
    this.window.XMLHttpRequest = FakeRequest
    new Ajax('/ajax-text.html', method: 'get')


describe "Ajax", module,
  "constructor":
    topic: Ajax

    "should create an instance of Ajax": (Ajax)->
      assert.instanceOf new Ajax(), Ajax

    "should assign the 'url' attribute": (Ajax)->
      ajax = new Ajax('/some.url')
      assert.same ajax.url, '/some.url'

    "should merge the global and local attributes": (Ajax)->
      options =
        method:   'get'
        encoding: 'cp1251'

      ajax = new Ajax('/some.url', options)

      assert.deepEqual ajax.options, this.Hash.merge(Ajax.Options, options)

    "should accept the event callbacks with the options": (Ajax)->
      call1 = ->
      call2 = ->

      ajax = new Ajax('/some.url', success: call1, failure: call2)

      assert.isTrue ajax.ones('success', call1)
      assert.isTrue ajax.ones('failure', call2)

  "#header":
    topic: Ajax

    "\b('name')":
      topic: (Ajax)->
        ajax = new Ajax('/some.url')
        ajax._ =
          getResponseHeader: (key)->
            "header data" if key is "the-key"
        ajax

      "should return a response header value": (ajax)->
        assert.equal ajax.header("the-key"), "header data"

      "should return 'undefined' if there is no request": (ajax)->
        ajax._ = null
        assert.isUndefined ajax.header("the-key")

    "\b('name', 'value')":
      topic: (Ajax)-> new Ajax('/some.url')

      "should assign the header to be sent with the request": (ajax)->
        ajax.header('my-header', 'my-data')
        assert.equal ajax.options.headers['my-header'], 'my-data'

      "should return the ajax request itself back to the code": (ajax)->
        assert.same ajax.header('my-header', 'my-value'), ajax

  "#successful()":
    topic: test_request

    "should say 'true' if the request is successful": (ajax)->
      ajax.status = 200
      assert.isTrue ajax.successful()
      ajax.status = 302
      assert.isTrue ajax.successful()

    "should say 'false' if the request had failed": (ajax)->
      ajax.status = 0
      assert.isFalse ajax.successful()

      ajax.status = 404
      assert.isFalse ajax.successful()

  "#cancel()":
    topic: test_request

    "should call 'abort' on the XHR object": (ajax)->
      called = false
      ajax._ = abort: -> called = true

      ajax.cancel()

      assert.isTrue called

    "should emit the 'cancel' event": (ajax)->
      ajax.__canceled = false

      called = false
      ajax.on 'cancel', -> called = true

      ajax.cancel()

      assert.isTrue called

  "#emit('event-name')":
    topic: test_request

    "should allow to emit events": (ajax)->
      called = false
      ajax.on 'something', -> called = true
      ajax.emit('something')

      assert.isTrue called

    "should emit an 'ajax:event-name' event on current document": (ajax)->
      called = false
      event  = null

      this.dom(this.document).on('ajax:test', (e)-> event = e; called = true)

      ajax.emit('test')

      assert.isTrue called
      assert.same   event.ajax, ajax

    "should return the request object back to the code": (ajax)->
      assert.same ajax.emit('stuff'), ajax


  "#send()":
    topic: test_request

    "should accept 'put' and 'delete' methods": (ajax)->
      for method in ['put', 'delete']
        ajax.options.method = method
        ajax.send()
        assert.equal ajax._.method, "post"
        assert.equal ajax._.params, "_method=#{method}"

      ajax.options.method = 'post'

    "should add the url-encoded header for url-encoded data": (ajax)->
      ajax.options.params = 'a$a=b$b'
      ajax.send()
      assert.equal ajax._.params, 'a%24a=b%24b'

    "should assign all the headers to the XHR object": (ajax)->
      ajax.options.headers = one: 'first', two: 'second'
      ajax.send()
      assert.equal ajax._.header.one, 'first'
      assert.equal ajax._.header.two, 'second'

    "should use XMLHttpRequest tunnel by default": (ajax)->
      ajax.send()
      assert.instanceOf ajax._, FakeRequest

    "should emit 'create' event before sending the request": (ajax)->
      request = null
      opened  = null
      ajax.on('create', -> request = @_; opened = !!@_.method)

      ajax.send()

      assert.isNotNull request
      assert.isFalse   opened

    "should emit 'request' event after sending the request": (ajax)->
      sent = null
      ajax.options.params = 'some=stuff'
      ajax.on('request', -> sent = !!@_.params)
      ajax.send()

      assert.isTrue sent

    "should return the request object itself back to the code": (ajax)->
      assert.same ajax.send(), ajax



  "params processing":
    topic: Ajax

    "should send the global params": (Ajax)->
      Ajax.Options.params = 'global=params'
      ajax = new Ajax()
      ajax.send()
      assert.equal ajax._.params, 'global=params'

    "should send the options params": (Ajax)->
      Ajax.Options.params = null
      ajax = new Ajax('/some.url', params: 'local=params')
      ajax.send()
      assert.equal ajax._.params, 'local=params'

    "should extract and send Form values": (Ajax)->
      form = new this.dom.Form(action: '/boo')
      ajax = new Ajax('/some.url', params: form)

      form.values = -> name1: 'value1', name2: 'value2'
      ajax.send()

      assert.equal ajax._.params, 'name1=value1&name2=value2'

    "should merge global and options params": (Ajax)->
      Ajax.Options.params = 'global=params'
      ajax = new Ajax('/some.url', params: local: 'data')

      ajax.send()

      assert.equal ajax._.params, 'global=params&local=data'


    "should set the GET request params into the url": (Ajax)->
      Ajax.Options.params = null
      ajax = new Ajax('/some.url', method: 'get', params: 'some=data')
      ajax.send()

      assert.equal ajax._.url, '/some.url?some=data'



  "auto-handling text/javascript an text/json responses":
    topic: test_request

    "should automatically eval the text/javascript responses in the global context": (ajax)->
      ajax.header = (name)-> 'text/javascript' if name is 'Content-type'
      ajax.responseText = "var test1='text/javascript test';"

      ajax.emit('success')

      assert.equal this.window.test1, 'text/javascript test'

    "should automatically parse the text/json responses": (ajax)->
      ajax.header = (name)-> 'text/json' if name is 'Content-type'
      ajax.responseText = '{"some": "value"}'

      ajax.emit('success')

      assert.deepEqual ajax.responseJSON, some: 'value'

    "should throw an error on a malformed json data": (ajax)->
      ajax.header = (name)-> 'text/json' if name is 'Content-type'
      ajax.responseText = "malformed data"

      try
        ajax.emit('success')
        assert.isTrue false
      catch e
        assert.equal e, "JSON error: malformed data"

    "should extract data from the X-JSON header": (ajax)->
      ajax.header = (name)-> '{"header": "data"}' if name is 'X-JSON'
      ajax.responseText = 'some text'
      ajax.emit('success')
      assert.deepEqual ajax.headerJSON, header: 'data'




  "spinners handling":
    topic: Ajax

    "should show the spinner when a request is created": (Ajax)->
      spinner = this.dom('#spinner')[0].hide()

      ajax = new Ajax('/some.url', spinner: '#spinner')
      ajax.emit('create')

      assert.isTrue spinner.visible()


    "should hide the spinner when a request is complete": (Ajax)->
      spinner = this.dom('#spinner')[0].show()

      ajax = new Ajax('/some.url', spinner: '#spinner')
      ajax.emit('complete')

      assert.isTrue spinner.hidden()

    "should hide the spinner when a request is canceled": (Ajax)->
      spinner = this.dom('#spinner')[0].show()

      ajax = new Ajax('/some.url', spinner: '#spinner')
      ajax.emit('cancel')

      assert.isTrue spinner.hidden()

    "should not hide a global spinner until all requests are finished": (Ajax)->
      spinner = this.dom('#spinner')[0].hide()
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






