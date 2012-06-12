#
# The standard confirmation dialogs
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog.Confirm extends Dialog

  constructor: (options)->
    options       or= {}
    options.title or= 'Confirm'
    options.icon  or= 'question-sign'

    super(options)

    @addClass 'lui-dialog-confirm'
    @on       'ok', 'hide'