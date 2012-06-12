#
# The standard info dialog subclass
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog.Info extends Dialog

  constructor: (options)->
    options       or= {}
    options.title or= 'Info'

    super(options)

    @addClass('lui-dialog-only-ok')
    @addClass('lui-dialog-with-icon')
    @addClass('lui-dialog-info')

    @on 'ok', 'hide'