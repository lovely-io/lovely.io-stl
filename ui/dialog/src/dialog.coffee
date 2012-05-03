#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog extends UI.Modal
  include: core.Options
  extend:
    Options:
      nolock:     false
      showHeader: true
      showFooter: true


  constructor: (options)->
    @$super(options).addClass('lui-dialog')

    @first('.lui-inner').append """
      <header>
        <h3>Hello world!</h3>
        <button class="lui-icon lui-icon-delete"></button>
      </header>
      <section>
        Hello world!
      </section>
      <footer>
        <button class="lui-button lui-button-help">Help</button>
        <button class="lui-button lui-button-ok">Ok</button>
        <button class="lui-button lui-button-cancel">Cancel</button>
      </footer>
    """

    return @

  #
  # Sets/Gets the dialog title
  #
  # @param {String} new title or nothing
  # @return {String|Dialog} the current title or the dialog itself
  #
  title: (string)->
    return @