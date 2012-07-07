Ruby On Rails UJS support module

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside

$    = require('dom')
core = require('core')
Ajax = require('ajax')


# tries to cancel the event via confirmation
user_cancels = (event, element)->
  message = element.attr('data-confirm')
  if message && !confirm(message)
    event.stop()
    return true


# sends an ajax request
send_ajax = (element, url, options)->
  Ajax.load url, core.ext(
    create:   -> element.emit 'ajax:loading',  ajax: @
    complete: -> element.emit 'ajax:complete', ajax: @
    cuccess:  -> element.emit 'ajax:success',  ajax: @
    cailure:  -> element.emit 'ajax:failure',  ajax: @
  , options)


# global events listeners
$(global.document).on
  # handles clicks on the remote links
  click: (event)->
    return unless link = event.find('a')

    url    = link.attr('href')
    method = link.attr('data-method')
    remote = link.attr('data-remote')

    return if user_cancels(event, link)
    event.stop() if remote || method

    if remote
      send_ajax link, url,
        method:  method || 'get'
        spinner: link.attr('data-spinner')

    else if method
      param = $('meta[name=csrf-param]').attr('content')
      token = $('meta[name=csrf-token]').attr('content')

      form  = "<form method='post'>"
      form += "<input type='hidden' name='#{param}' value='#{token}' />" if param && token
      form += "<input type='hidden' name='_method' value='#{method}' />"
      form += "</form>"

      $(form)[0].attr('action', url).insertTo(global.document.body).submit()

    return # nothing


  # handles remote forms submissions
  submit: (event)->
    form = event.target

    if form.attr('data-remote') && !user_cancels(event, form)
      event.stop()

      send_ajax form, form.attr('action') || global.document.location.href,
        method:  form.attr('method') || 'get'
        params:  form.serialize()
        spinner: form.attr('data-spinner') || form.first('.spinner')

    return # nothing
```
