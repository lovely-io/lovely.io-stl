#
# This file handles the dom-element manipulation
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include

  #
  # Clones the element with all it's content
  #
  # @return {Element} a clone
  #
  clone: ->
    new Element(@_.cloneNode(true))

  #
  # Removes all the child nodes out of the element
  #
  # @return {Element} this
  #
  clear: ->
    while @_.firstChild
      @_.removeChild(@_.firstChild)
    return @

  #
  # Checks if the element doesn't have any actual content in it
  #
  # @return {Boolean} check result
  #
  empty: ->
    /^\s*$/.test(@html())

  #
  # Sets of gets the html content of the element as a string
  #
  # @param {String} html content if setting
  # @return {String|Element} this element or html content
  #
  html: (content)->
    if content is undefined then @_.innerHTML else @update(content)

  #
  # Sets of gets the element's content as a plain text
  #
  # @param {String} textual content if setting
  # @return {String|Element} this element or textual content
  #
  text: (text) ->
    if text is undefined then @_.textContent
    else @update(document.createTextNode(text))

  #
  # Removes the element out of the dom-tree
  #
  # @return {Element}
  #
  remove: ->
    @_.parentNode && @_.parentNode.removeChild(@_)
    return @

  #
  # Replaces the element with coven content
  #
  # @param {String|Element|Iterable} content
  # @return {Element} this
  #
  replace: (content)->
    @insert(content, 'instead')

  #
  # Replaces the element content
  #
  # @param {String|Element|Iterable} content
  # @return {Element} this
  #
  update: (content) ->
    if typeof(content) isnt 'object'
      [content, scripts] = extract_scripts(''+ content)

      try
        @_.innerHTML = content
      catch e # IE crashes here on some elements
        return @clear().insert(content)

      global_eval(scripts)

    else @clear().insert(content)

    return @
    
  #
  # Inserts the given content into the given position
  #
  # @param {String|Element|Iterable} content
  # @param {String} optional position 'bottom'/'top'/'before'/'after'/'instead'
  # @return {Element} this
  #
  insert: (content, position) ->
    element  = @_
    position = 'bottom' if position is undefined

    if typeof(content) isnt 'object'
      [content, scripts] = extract_scripts(''+content)

    content  = content._ if content._
    content  = Element_create_fragment(
      (if position in ['bottom', 'top'] then element
      else element.parentNode), content
    ) if content.nodeType is undefined

    Element_insert[position](element, content)

    global_eval(scripts)

    return @
    
  #
  # Inserts this element into the given one at given position
  #
  # @param {Element|HTMLElement|String} destination or '#element-id' string
  # @param {String} optional position
  # @return {Element} this
  #
  insertTo: (element, position) ->
    Element.resolve(element).insert(@, position)

    return @
    
  #
  # Appends the argument elements to this element
  #
  # @param {String|Element} content
  # ....
  # @return {Element} this
  #
  append: (first) ->
    @insert if typeof(first) is "string" then A(arguments).join('') else arguments





# private

# various element insertion handlers
Element_insert =
  bottom: (target, content)->
    target.appendChild(content)

  top: (target, content)->
    if target.firstChild is null
      target.appendChild(content)
    else
      target.insertBefore(content, target.firstChild)

  after: (target, content)->
    if target.nextSibling is null
      target.parentNode.appendChild(content)
    else
      target.parentNode.insertBefore(content, target.nextSibling)

  before: (target, content)->
    target.parentNode.insertBefore(content, target)

  instead: (target, content)->
    target.parentNode.replaceChild(content, target)


# makes a document fragment object out of given content
Element_create_fragment = (context, content)->
  if typeof(content) is 'string'
    tag   = context.tagName
    tmp   = Element_tmp_cont
    block = if tag of Element_wraps then Element_wraps[tag] else ['', '', 1]
    depth = block[2]

    tmp.innerHTML = block[0] + '<'+ tag + '>' + content + '</'+ tag + '>' + block[1]

    while depth-- isnt 0
      tmp = tmp.firstChild

    content = tmp.childNodes

    while content.length isnt 0
      Element_fragment.appendChild(content[0])

  else # converting iterables into a framgent
    `for (var i=0, length = content.length, node; i < length; i++) {
      node = content[content.length === length ? i : 0];
      Element_fragment.appendChild(node._ || node);
    }`

  return Element_fragment

# caching the fragment and temporary context objects
Element_fragment = document.createDocumentFragment()
Element_tmp_cont = document.createElement('div')

# Various trouble elements wrapping blocks
Element_wraps =
  TBODY:  ['<TABLE>',            '</TABLE>',                           2]
  TR:     ['<TABLE><TBODY>',     '</TBODY></TABLE>',                   3]
  TD:     ['<TABLE><TBODY><TR>', '</TR></TBODY></TABLE>',              4]
  COL:    ['<TABLE><COLGROUP>',  '</COLGROUP><TBODY></TBODY></TABLE>', 2]
  LEGEND: ['<FIELDSET>',         '</FIELDSET>',                        2]
  AREA:   ['<map>',              '</map>',                             2]
  OPTION: ['<SELECT>',           '</SELECT>',                          2]

Element_wraps.OPTGROUP = Element_wraps.OPTION
Element_wraps.THEAD    = Element_wraps.TBODY
Element_wraps.TFOOT    = Element_wraps.TBODY
Element_wraps.TH       = Element_wraps.TD