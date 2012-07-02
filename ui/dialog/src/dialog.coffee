#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog extends Modal
  include: core.Options
  extend:
    Options: # default options
      nolock:      false
      showHelp:    false
      showHeader:  true
      showButtons: true
      onlyOk:      false
      title:       null    # title to preset
      html:        null    # html to preset
      icon:        null    # UI-core icon name without the `lui-icon-` prefix
      url:         null    # an url to load
      ajax:        null    # ajax options

  #
  # The default constructor
  #
  # @param {Object} options
  # @return {Dialog} this
  #
  constructor: (options)->
    @setOptions(options or= {})
    delete(options[key]) for key of Dialog.Options when key isnt 'nolock'

    @$super(options).addClass('lui-dialog')

    @append """
      <header>
        <h3>&nbsp;</h3>

        <button class="lui-dialog-cancel lui-button"><i class="lui-icon-remove"></i></button>
        <button class="lui-dialog-help   lui-button"><i class="lui-icon-help"></i></button>
      </header>
      <section>

      </section>
      <footer>
        <button class="lui-dialog-help   lui-button lui-icon-help">Help</button>
        <button class="lui-dialog-ok     lui-button lui-icon-ok">Ok</button>
        <button class="lui-dialog-cancel lui-button lui-icon-remove">Cancel</button>
      </footer>
    """

    @header = @dialog.first('header')
    @body   = @_inner = @dialog.first('section')
    @footer = @dialog.first('footer')

    # adjusting the view to the options
    @addClass 'lui-dialog-nohelp'   unless @options.showHelp
    @addClass 'lui-dialog-noheader' unless @options.showHeader
    @addClass 'lui-dialog-nofooter' unless @options.showButtons
    @addClass 'lui-dialog-only-ok'  if     @options.onlyOk

    @body.insert(@_icon  = new UI.Icon(@options.icon)) if @options.icon
    @title  @options.title              if @options.title
    @html   @options.html               if @options.html
    @load   @options.url, @options.ajax if @options.url

    # hooking up the events
    @header.first('.lui-dialog-help').on('click',   => @emit('help'))
    @header.first('.lui-dialog-cancel').on('click', => @emit('cancel'))
    @footer.first('.lui-dialog-ok').on('click',     => @emit('ok'))
    @footer.first('.lui-dialog-help').on('click',   => @emit('help'))
    @footer.first('.lui-dialog-cancel').on('click', => @emit('cancel'))

    @on 'cancel', 'hide'

  #
  # Sets/Gets the dialog title
  #
  # @param {String} new title or nothing
  # @return {String|Dialog} the current title or the dialog itself
  #
  title: (string)->
    if string?
      @header.first('h3').html(string)
    else
      @header.first('h3').html()


  #
  # Setting up the screen locker while loading
  #
  # @param {String} url
  # @param {Object} ajax options
  # @return {Dialog} this
  #
  load: (url, options)->
    @append(@locker or= new UI.Locker())

    options or= {}; options.method or= 'get'
    @ajax = new Ajax(url, options).on('complete', =>
      @update @ajax.responseText
      @emit 'load'
    ).send()

    return @

  #
  # Overloading the method to place the icon in place all the time
  #
  # @param {mixed} content
  # @return {Dialog} this
  #
  update: ->
    Modal::update.apply(@, arguments)
    @body.insert(@_icon, 'top') if @_icon
    return @

  #
  # Overloading the method to place the icon in place all the time
  #
  # @param {mixed} content
  # @return {Dialog} this
  #
  html: ->
    Modal::update.apply(@, arguments)
    @body.insert(@_icon, 'top') if @_icon
    return @


#
# Make the inner block scroll
#
Dialog::limit_size = (size)->
  @body._.style.maxHeight = size.y - @header._.offsetHeight - @footer._.offsetHeight - 40 + 'px'
  @body._.style.maxWidth  = size.x - 40 + 'px'

  return @
