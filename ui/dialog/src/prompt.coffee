#
# The standard prompt dialogs
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Dialog.Prompt extends Dialog

  constructor: (options)->
    options       or= {}
    options.title or= 'Prompt'

    input_type = options.type || 'text'
    delete(options.type)

    super(options)
    @addClass('lui-dialog-with-icon')
    @addClass('lui-dialog-prompt')

    @input = new Input(type: input_type).insertTo(@)

    unless input_type is 'textarea'
      @input.on 'enter', => @emit('ok')

    @on 'ok', 'hide'
    @on 'show', => @input.focus()

  #
  # Automatically adding the `value` parameter
  # to the `ok` events, so you could get the entered
  # value immediatelly
  #
  emit: (name, options)->
    if name is 'ok'
      options or= {}
      options.value = @input.value()

    super name, options