#
# Generic modal screen unit. for dialogs and that sort of stuff
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Modal extends Element
  extend:
    current: null
    offsetX: 50
    offsetY: 50

  #
  # Basic constructor
  #
  # NOTE: the `html` attribute will be inserted into the `inner`
  #       block, not inside of the main modal container!
  #
  # @param {Object} html options
  # @return {Modal} self
  #
  constructor: (options)->
    options = merge_options(options, { class: 'lui-modal lui-locker' })
    html    = options.html || '';
    options.html = """
      <div class="lui-aligner"></div><div class="lui-inner"></div>
    """
    options['class'] += ' lui-modal-nolock' if options.nolock is true; delete(options.nolock)

    super('div', options)

    @_inner = @dialog = @first('.lui-inner')
    @_inner.insert(html)

    return @

  #
  # Bypassing the {Element#html} calls to the inner element
  #
  # @return {Modal} self
  #
  html: ->
    @_inner.html.apply(@_inner, arguments)
    return @

  #
  # Bypassing the {Element#html} calls to the inner element
  #
  # @return {Modal} self
  #
  text: ->
    @_inner.text.apply(@_inner, arguments)
    return @

  #
  # Bypassing the {Element#insert} calls to the inner element
  #
  # @return {Modal} self
  #
  insert: ()->
    @_inner.insert.apply(@_inner, arguments)
    return @

  #
  # Bypassing the {Element#update} calls to the inner element
  #
  # @return {Modal} self
  #
  update: ()->
    @_inner.update.apply(@_inner, arguments)
    return @

  #
  # Bypassing the {Element#clear} calls to the inner element
  #
  # @return {Modal} self
  #
  clear: ()->
    @_inner.clear()
    return @

  #
  # Automatically inserts the element into the `document.body`
  #
  # @return {Modal} self
  #
  show: ()->
    hide_all_modals()

    @insertTo(document.body)
    @$super.apply(@, arguments)
    @limit_size(dom_window.size())

    Modal.current = @constructor.current = @emit('show')

  #
  # Removes the whole thing out of the `document.body`
  #
  # @return {Modal} self
  #
  hide: ->
    Modal.current = @constructor.current = null
    @emit('hide').remove()

  #
  # Sets the size limits for the image
  #
  # @param {Object} x: N, y: N size
  # @return {Zoom} this
  #
  limit_size: (size)->
    @dialog._.style.maxWidth  = size.x - (@constructor.offsetX || Modal.offsetX) + 'px'
    @dialog._.style.maxHeight = size.y - (@constructor.offsetX || Modal.offsetY) + 'px'

    return @


# hides all visible modals on the page
hide_all_modals = ->
  dom('div.lui-modal').forEach('remove')

# hide all modals when the user presses 'escape'
dom(document).on('esc', hide_all_modals)
dom(document).on 'click', (event)->
  if Modal.current && (Modal.current == event.target || !event.find('.lui-modal'))
    Modal.current.hide()

# setting up the dialog max-sizes with the window
resize_timeout = new Date()
dom_window = dom(window).on 'resize', ->
  if Modal.current isnt null && (new Date() - resize_timeout) > 1
    resize_timeout = new Date()
    Modal.current.limit_size(@size())



