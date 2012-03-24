#
# Generic modal screen unit. for dialogs and that sort of stuff
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Modal extends Element
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
      <div class="lui-aligner"></div>
      <div class="lui-inner"></div>
    """
    options['class'] += ' lui-modal-nolock' if options.nolock is true; delete(options.nolock)

    super('div', options)

    @_inner = @first('.lui-inner')
    @_inner.update(html)

    @on 'click', (event)->
      @hide() if event.target is @


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

  #
  # Removes the whole thing out of the `document.body`
  #
  hide: ()->
    @remove()


# hides all visible modals on the page
hide_all_modals = ->
  dom('div.lui-modal').forEach('remove')

# hide all modals when the user presses 'escape'
dom(document).on('esc', hide_all_modals)