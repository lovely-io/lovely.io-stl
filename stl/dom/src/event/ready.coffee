#
# This module provies the dom-ready handler
# for the `Document` class
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Document.include
  on: (name, callback)->
    Element_events.on.apply(@, arguments)

    if name is 'ready'
      doc = @_
      id  = uid(doc)

      if Ready_documents[id]
        callback.apply(@) # if the document is alrady loaded
      else
        unless id of Ready_documents
          Ready_documents[id] = false
          ready = bind(@emit, @, 'ready')

          if 'readyState' of doc
            do ->
              if (doc.readyState in ['loaded', 'complete'])
                ready()
              else
                setTimeout(arguments.callee, 50)
          else
            doc.addEventListener('DOMContentLoaded', ready, false)

    return @

# the ready documents index
Ready_documents = []