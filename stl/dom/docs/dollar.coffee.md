The main function of the DOM API, it can take several types of arguments

Search:

    :js
    $('some#css.rule'[, optionally a context]) // -> NodeList

Creation:

    :js
    $('<div>bla bla bla</div>') // -> NodeList

DOM-Ready:

    :js
    $(function() { /* dom-ready content */ }); // -> Document

DOM-Wrapper:

    :js
    $(element)  // -> Element
    $(document) // -> Document
    $(window)   // -> Window
    ...

@param {String|Function|Element|Document} stuff
@return {NodeList|Wrapper} result

```coffee-aside
$ = (value, context) ->
  switch typeof(value)
    when 'string'

      if /^#[^ \.\[:]+$/i.test(value) # quick by-id search
        value = document.getElementById(value.substr(1))
        value = if value is null then [] else [value]
      else if value[0] is '<' # '<div>boo hoo</div>' to node-list conversion
        return new Element('div').html(value).children()
      else
        if `context == null`
          context = current_Document
        else if !(context instanceof Wrapper)
          context = wrap(context)

        value = context.find(value, true)

      value = new NodeList(value)

    when 'function' then value = current_Document.on('ready', value)
    when 'object'   then value = wrap(value)

  return value
```
