#
# This module provies the dom-ready handler
# for the `Document` class
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Document.include
  on: (name)->
    if name is 'ready' and @_ir is undefined
      doc   = @_
      ready = bind(@emit, @, 'ready')

      if 'readyState' of doc # IE and Konqueror
        do ->
          if (doc.readyState in ['loaded', 'complete'])
            ready()
          else
            setTimeout(arguments.callee, 50)
      else
        doc.addEventListener('DOMContentLoaded', ready, false)

      @_ir = true # prevening from double initialization

    this.$super.apply(this, arguments)