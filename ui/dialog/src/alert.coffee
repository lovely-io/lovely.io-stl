#
# The standard alert dialog subclass
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog.Alert extends Dialog
  #
  # Constructor
  #
  constructor: (options)->
    super(options)
    @addClass('lui-dialog-alert')
    @on 'ok', 'hide'