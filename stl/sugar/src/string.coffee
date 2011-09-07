#
# The "string".toSomething() shortcuts
#
# Copyright (C) 2011 Nikolay Nemshilov
#

SKIPPED_NAMES = (
  "$super constructor document window _listeners on no ones "+
  "delegate undelegate delegates"
).split(' ')

# Transferring the `dom.NodeList` methods to `String.prototype`
for name of dom.Element.prototype
  continue if name in SKIPPED_NAMES
  if dom.NodeList.prototype[name] and !String.prototype[name]
    do (name)->
      String.prototype[name] = ->
        collection = dom("#{@}")
        collection[name].apply(collection, arguments)


# Making the UJS hooks for the String.prototype
for method, reference of {on: 'delegate', no: 'undelegate', ones: 'delegates'}
  do (method, reference)->
    String.prototype[method] = ->
      doc = dom(document)
      doc[reference].apply(doc, ["#{@}"].concat(A(arguments)))
      return @
