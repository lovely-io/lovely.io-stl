#
# The dom.Element 'onSomething' shortcuts
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# builds the 'onEvent' shortucts
#
# @param {core.Class} dom-wrapper class
# @param {String} space separated event names list
#
make_shortcuts = (Klass, EVENTS)->
  for name in EVENTS.split(' ')
    do (name)->
      method = "on#{name[0].toUpperCase() + name.substr(1)}"
      Klass.prototype[method] = dom.NodeList.prototype[method] = String.prototype[method] = ->
        @on.apply(@, [name].concat(A(arguments)))

  return # nothing


# extending the actual classes
make_shortcuts dom.Element,
  "click rightclick contextmenu mousedown mouseup "+
  "mouseover mouseout mousemove keypress keydown keyup"

make_shortcuts dom.Input,
  "submit reset focus blur disable enable change"

make_shortcuts dom.Form,
  "submit reset focus blur disable enable change"
