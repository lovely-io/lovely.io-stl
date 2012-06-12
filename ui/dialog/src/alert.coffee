#
# The standard alert dialog subclass
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog.Alert extends Dialog

  constructor: (options)->
    options       or= {}
    options.title or= 'Alert'
    options.icon  or= 'warning-sign'
    options.onlyOk  = true unless 'onlyOk' in options

    super(options)

    @addClass 'lui-dialog-alert'
    @on       'ok', 'hide'