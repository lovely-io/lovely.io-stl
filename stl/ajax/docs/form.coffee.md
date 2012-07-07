The DOM Form unit AJAX related extensions

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
Form.include
  remote: false  # remotized form marker
```

Sends the form via an ajax request

@param {Object} ajax options
@return {Form} this

```coffee-aside
  send: (options)->
    options or= {}
    options.method  = options.method  || @_.method || 'post'
    options.spinner = options.spinner || @first('.spinner')
    options.params  = @

    @ajax = new Ajax(@_.action || global.document.location.href, options)
    @ajax.on 'complete', bind(@enable, @)
    @ajax.on 'cancel',   bind(@enable, @)
    @ajax.send()

    setTimeout(bind(@disable, @), 1) # WebKit needs this delay with IFrame requests

    return @
```

Cancels an ongoing Ajax request initialized by the {#send} methdo

@return {Form} this

```coffee-aside
  cancelAjax: ->
    @ajax.cancel() if @ajax instanceof Ajax
    return @
```

Marks the form to be send via Ajax on submit

@param {Object} ajax options
@return {Form} this

```coffee-aside
  remotize: (options)->
    unless @remote
      @on 'submit', Form_remote_send, options
      @remote = true

    return @
```

Cancels the effect of the {#remotize} mehtod

@return {Form} this

```coffee-aside
  unremotize: ->
    if @remote
      @no 'submit', Form_remote_send
      @remote = false

    return @
```

Converts the form values into a query string

@return {String} a query string

```coffee-aside
  serialize: ->
    Hash.toQueryString(@values())


# private

Form_remote_send = (event, options)->
  event.stop()
  @send(options)
```
