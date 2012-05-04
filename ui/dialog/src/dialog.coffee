#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog extends UI.Modal
  include: core.Options
  extend:
    Options: # default options
      nolock:      false
      showHelp:    false
      showHeader:  true
      showButtons: true
      title:       null    # title to preset
      html:        null    # html to preset
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
    delete(options[key]) for key of @options

    @$super(options).addClass('lui-dialog')

    @append """
      <header>
        <h3>&nbsp;</h3>

        <button class="lui-icon lui-icon-delete"></button>
        <button class="lui-icon lui-icon-help"></button>
      </header>
      <section>

      </section>
      <footer>
        <button class="lui-button lui-button-help">Help</button>
        <button class="lui-button lui-button-ok">Ok</button>
        <button class="lui-button lui-button-cancel">Cancel</button>
      </footer>
    """

    @header = @dialog.first('header')
    @body   = @_inner = @dialog.first('section')
    @footer = @dialog.first('footer')

    # adjusting the view to the options
    @addClass 'lui-dialog-nohelp'   unless @options.showHelp
    @addClass 'lui-dialog-noheader' unless @options.showHeader
    @addClass 'lui-dialog-nofooter' unless @options.showButtons

    @title @options.title if @options.title
    @html  @options.html  if @options.html
    @load  @options.url, @options.ajax if @options.url

    # hooking up the events
    @header.first('.lui-icon-help').on('click',     => @emit('help'))
    @header.first('.lui-icon-delete').on('click',   => @emit('cancel'))
    @footer.first('.lui-button-help').on('click',   => @emit('help'))
    @footer.first('.lui-button-ok').on('click',     => @emit('ok'))
    @footer.first('.lui-button-cancel').on('click', => @emit('cancel'))

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
    ).send()

    return @