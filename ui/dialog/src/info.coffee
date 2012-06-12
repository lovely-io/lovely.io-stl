#
# The standard info dialog subclass
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog.Info extends Dialog

  constructor: (options)->
    options       or= {}
    options.title or= 'Info'
    options.icon  or= 'info-sign'
    options.onlyOk  = true unless 'onlyOk' in options

    super(options)

    @addClass 'lui-dialog-info'
    @on       'ok', 'hide'