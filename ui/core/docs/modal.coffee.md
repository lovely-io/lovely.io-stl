Generic modal screen unit. for dialogs and that sort of stuff

Copyright (C) 2012 Nikolay Nemshilov

```coffee-aside
class Modal extends Element
  extend:
    current: null
    offsetX: 40
    offsetY: 40
```

Basic constructor

NOTE: the `html` attribute will be inserted into the `inner`
      block, not inside of the main modal container!

@param {Object} html options
@return {Modal} self

```coffee-aside
  constructor: (options)->
    options = merge_options(options, { class: 'lui-modal lui-locker' })
    html    = options.html || '';
    options.html = '<div class="lui-inner"></div>'

    options['class'] += ' lui-modal-nolock'  if options.nolock is true; delete(options.nolock)
    options['class'] += ' lui-modal-overlap' if options.overlap is true; delete(options.overlap)

    super('div', options)

    @_inner = @dialog = @first('.lui-inner')
    @_inner.insert(html)

    return @
```

Bypassing the {Element#html} calls to the inner element

@return {Modal} self

```coffee-aside
  html: ->
    @_inner.html.apply(@_inner, arguments)
    return @
```

Bypassing the {Element#html} calls to the inner element

@return {Modal} self

```coffee-aside
  text: ->
    @_inner.text.apply(@_inner, arguments)
    return @
```

Bypassing the {Element#insert} calls to the inner element

@return {Modal} self

```coffee-aside
  insert: ()->
    @_inner.insert.apply(@_inner, arguments)
    return @
```

Bypassing the {Element#update} calls to the inner element

@return {Modal} self

```coffee-aside
  update: ()->
    @_inner.update.apply(@_inner, arguments)
    return @
```

Bypassing the {Element#clear} calls to the inner element

@return {Modal} self

```coffee-aside
  clear: ()->
    @_inner.clear()
    return @
```

Automatically inserts the element into the `document.body`

@return {Modal} self

```coffee-aside
  show: ()->
    hide_all_modals() unless @hasClass('lui-modal-overlap')

    @insertTo(document.body)
    @$super.apply(@, arguments)
    @limit_size(dom_window.size())

    Modal.current = @constructor.current = @emit('show')
```

Removes the whole thing out of the `document.body`

@return {Modal} self

```coffee-aside
  hide: ->
    Modal.current = @constructor.current = null
    @emit('hide').remove()
```

Sets the size limits for the image

@param {Object} x: N, y: N size
@return {Zoom} this

```coffee-aside
  limit_size: (size)->
    @dialog._.style.maxWidth  = size.x - (@constructor.offsetX || Modal.offsetX) + 'px'
    @dialog._.style.maxHeight = size.y - (@constructor.offsetX || Modal.offsetY) + 'px'

    return @


# hides all visible modals on the page
hide_all_modals = ->
  modals = dom('div.lui-modal'); last_modal = modals[modals.length - 1]
  if last_modal && last_modal.hasClass('lui-modal-overlap')
    last_modal.remove()
  else
    modals.forEach('remove')

# hide all modals when the user presses 'escape'
dom(document).on('esc', hide_all_modals)
dom(document).on 'click', (event)->
  if Modal.current && (Modal.current == event.target || !event.find('.lui-modal'))
    Modal.current.hide()
    Modal.current = dom('div.lui-modal').pop() || null

# setting up the dialog max-sizes with the window
resize_timeout = new Date()
dom_window = dom(window).on 'resize', ->
  if Modal.current isnt null && (new Date() - resize_timeout) > 1
    resize_timeout = new Date()
    Modal.current.limit_size(@size())
```
