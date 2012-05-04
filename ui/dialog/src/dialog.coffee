#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog extends UI.Modal
  extend:
    Options: # default options
      nolock:     false
      showHeader: true
      showFooter: true
      showHelp:   false


  #
  # The default constructor
  #
  # @param {Object} options
  # @return {Dialog} this
  #
  constructor: (options)->
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
    @body   = @dialog.first('body')
    @footer = @dialog.first('footer')

    @header.first('.lui-icon-help').on('click',     => @emit('help'))
    @header.first('.lui-icon-delete').on('click',   => @emit('cancel'))
    @footer.first('.lui-button-help').on('click',   => @emit('help'))
    @footer.first('.lui-button-ok').on('click',     => @emit('ok'))
    @footer.first('.lui-button-cancel').on('click', => @emit('cancel'))

    @on 'cancel', 'hide'

    return @

  #
  # Sets/Gets the dialog title
  #
  # @param {String} new title or nothing
  # @return {String|Dialog} the current title or the dialog itself
  #
  title: (string)->
    return @

