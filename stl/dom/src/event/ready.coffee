#
# This module provies the dom-ready handler
# for the `Document` class
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Document.include
  on: (name, callback)->
    this.$super.apply(@, arguments)

    if name is 'ready'
      doc = @_
      id  = uid(doc)

      if doc.readyState in ['interactive', 'loaded', 'complete']
        callback.apply(@) # if the document is alrady loaded
      else if !(id of Ready_documents)
        Ready_documents[id] = @
        doc.addEventListener('DOMContentLoaded', ->
          Ready_documents[id].emit('ready')
        , false)

    return @

# the ready documents index
Ready_documents = []