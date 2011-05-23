#
# Various `dom.Element` unit patches
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hooking up the manual CSS-search engine
if Search_module
  Element.prototype.first = Search_module.first
  Element.prototype.find  = Search_module.find

#
# some old browsers don't have the `getBoundingClientRect()` method
# so we provide a manual calculations for that case
#
unless 'getBoundingClientRect' of document.documentElement
  Element.include
    position: (position)->
      if position is undefined
        element  = @_
        top      = element.offsetTop
        left     = element.offsetLeft
        parent   = element.offsetParent

        while parent
          top  += parent.offsetTop
          left += parent.offsetLeft

          parent = parent.offsetParent

        return x: left, y: top

      else
        return this.$super(position)
