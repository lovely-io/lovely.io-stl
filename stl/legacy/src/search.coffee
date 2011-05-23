#
# This file provides the `document.querySelector` feature
# replacement for old browsers that don't have it, plus IE8
# which doesn't support some standatard CSS3 selectors
#
# Copyright (C) 2011 Nikolay Nemshilov
#

if !document.querySelector or BROWSER_IS_OLD_IE

  Search_module = do ->

    ################################################################
    # The manual css-search engine
    ################################################################

    #
    # The token searchers collection
    #
    search =
      # search for any descendant nodes
      ' ': (element, tag)->
        item for item in element.getElementsByTagName(tag)

      # search for immidate descendant nodes
      '>': (element, tag)->
        result = []; node = element.firstChild
        while node
          if tag is '*' or node.tagName is tag
            result.push(node)
          node = node.nextSibling
        result

      # search for immiate sibling nodes
      '+': (element, tag)->
        while element = element.nextSibling
          if element.nodeType is 1
            return if tag is '*' or element.tagName is tag then [element] else []
        return []

      # search for late sibling nodes
      '~': (element, tag)->
        result = []
        while element = element.nextSibling
          if tag is '*' or element.tagName is tag
            result.push(element)
        return result


    #
    # Collection of pseudo selector matchers
    #
    pseudos =
      not: (node, css_rule) ->
        node.nodeType is 1 && !$(node).match(css_rule)

      checked: (node)->
        node.checked is true

      enabled: (node)->
        node.disabled is false

      disabled: (node)->
        node.disabled is true

      selected: (node)->
        node.selected is true

      empty: (node)->
        !node.firstChild

      'first-child': (node, node_name)->
        while node = node.previousSibling
          if node.nodeType is 1 and (node_name is null or node.nodeName is node_name)
            return false
        return true

      'first-of-type': (node)->
        pseudos['first-child'](node, node.nodeName)

      'last-child': (node, node_name)->
        while node = node.nextSibling
          if node.nodeType is 1 and (node_name is null or node.nodeName is node_name)
            return false
        return true

      'last-of-type': (node)->
        pseudos['last-child'](node, node.nodeName)

      'only-child': (node, node_name)->
        pseudos['first-child'](node, node_name) and
        pseudos['last-child'](node, node_name)

      'only-of-type': (node)->
        pseudos['only-child'](node, node.nodeName)

      'nth-child': (node, number, node_name, reverse)->
        index = 1; a = number[0]; b = number[1]

        while node = (if reverse is true then node.nextSibling else node.previousSibling)
          if node.nodeType is 1 and (node_name is undefined or node.nodeName is node_name)
            index++

        if b is undefined then (index is a) else ((index - b) % a is 0 and (index - b) / a >= 0)

      'nth-of-type': (node, number)->
        pseudos['nth-child'](node, number, node.nodeName)

      'nth-last-child': (node, number)->
        pseudos['nth-child'](node, number, undefined, true)

      'nth-last-of-type': (node, number)->
        pseudos['nth-child'](node, number, node.nodeName, true)


    # the regexps collection
    chunker   = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^\[\]]*\]|['"][^'"]*['"]|[^\[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?/g
    id_re     = /#([\w\-_]+)/
    tag_re    = /^[\w\*]+/
    class_re  = /\.([\w\-\._]+)/
    pseudo_re = /:([\w\-]+)(\((.+?)\))*$/
    attrs_re  = /\[((?:[\w\-]*:)?[\w\-]+)\s*(?:([!\^$*~|]?=)\s*((['"])([^\4]*?)\4|([^'"][^\]]*?)))?\]/

  #################################################################################
  #################################################################################
  #################################################################################

    #
    # Builds an atom matcher
    #
    # @param {String} atom definition
    # @return {Object} atom matcher
    #
    atoms_cache = {}
    build_atom = (in_atom)->
      if !atoms_cache[in_atom]
        id = null; tag = null; classes = null; classes_length = null;
        attrs = null; pseudo = null; values_of_pseudo = null;
        match = null; func = null; desc = {}; atom = in_atom;

        # grabbing the attributes
        while match = atom.match(attrs_re)
          attrs = attrs || {}
          attrs[match[1]] = { o: match[2] || '', v: match[5] || match[6] || '' }
          atom = atom.replace(match[0], '')

        # extracting the pseudos
        if match = atom.match(pseudo_re)
          pseudo = match[1]
          values_of_pseudo = if match[3] is '' then null else match[3]

          if pseudo.substr(0,3) is 'nth'
            # preparsing the nth-child pseoudo numbers
            values_of_pseudo = values_of_pseudo.toLowerCase();

            if values_of_pseudo is 'n'
              # no need in the pseudo then
              pseudo = null
              values_of_pseudo = null
            else
              values_of_pseudo = '2n+1' if values_of_pseudo is 'odd'
              values_of_pseudo = '2n'   if values_of_pseudo is 'even'

              if m = /^([+\-]?\d*)?n([+\-]?\d*)?$/.exec(values_of_pseudo)
                values_of_pseudo = [
                  if m[1] is '-' then -1 else (parseInt(m[1], 10) || 1),
                  parseInt(m[2], 10) || 0
                ]
              else
                values_of_pseudo = [parseInt(values_of_pseudo, 10), undefined]

          atom = atom.replace(match[0], '')


        # getting all the other options
        id      = (atom.match(id_re)    || [1, null])[1]
        tag     = (atom.match(tag_re)   || '*').toString().toUpperCase()
        classes = (atom.match(class_re) || [1, ''])[1].split('.')
        classes = (klass for klass in classes when klass isnt '')
        classes_length = classes.length

        desc.tag = tag

        if id || classes.length || attrs || pseudo
          # optimizing a bit the values for quiker runtime checks
          id      = id     || false
          attrs   = attrs  || false
          pseudo  = if pseudo of pseudos then pseudos[pseudo] else false
          classes = if classes_length then classes else false

          desc.filter = (elements)->
            result = []
            for node in elements

              #
              # ID check
              #
              if id isnt false and node.id isnt id
                continue

              #
              # Class names check
              #
              if classes isnt false
                failed = false
                node_classes = node.className.split(' ')
                for klass in classes
                  found = false
                  for name in node_classes
                    if klass is name
                      found = true
                      break

                  if !found
                    failed = true
                    break

                continue if failed


              #
              # Attributes check
              #
              if attrs isnt false
                failed = false
                for key, param of attrs
                  attr    = if key is 'class' then node.className else (node.getAttribute(key) || '')
                  operand = param.o
                  value   = param.v

                  if (
                    (operand is ''   and (if key is 'class' or key is 'lang' then (attr is '')
                    else node.getAttributeNode(key) is null))                              or
                    (operand is '='  and attr isnt value)                                    or
                    (operand is '*=' and attr.indexOf(value) is -1)                          or
                    (operand is '^=' and attr.indexOf(value) isnt 0)                         or
                    (operand is '$=' and attr.substr(attr.length - value.length) isnt value) or
                    (operand is '~=' and " #{attr} ".indexOf(" #{value} ") is -1)            or
                    (operand is '|=' and "-#{attr}-".indexOf("-#{value}-") is -1)
                  )
                    failed = true
                    break

                continue if failed


              #
              # Pseudo selectors check
              #
              if pseudo isnt false
                continue unless pseudo(node, values_of_pseudo)

              result.push(node)

            return result

        atoms_cache[in_atom] = desc

      return atoms_cache[in_atom]

    #
    # Builds a single selector out of a simple rule chunk
    #
    # @param {Array} of a single rule tokens
    # @return {Function} selector
    #
    tokens_cache = {}
    build_selector = (rule)->
      rule_key = rule.join('');

      unless tokens_cache[rule_key]
        for entry in rule
          entry[1] = build_atom(entry[1])

        # creates a list of uniq nodes
        uniq = (elements)->
          result = []; ids = []; id = null;
          for element in elements
            id = uid(element)
            unless id of ids
              result.push(element)
              ids[id] = true

          return result

        # performs the actual search of subnodes
        find_subnodes = (element, atom)->
          result = search[atom[0]](element, atom[1].tag)
          result = atom[1].filter(result) if 'filter' of atom[1]
          result


        # building the actual selector function
        tokens_cache[rule_key] = (element)->
          founds = null; sub_founds = null;

          for entry, i in rule
            if i is 0
              founds = find_subnodes(element, entry)
            else
              founds = uniq(founds) if i > 1

              `for (var j=0; j < founds.length; j++) {
                sub_founds = find_subnodes(founds[j], rule[i]);

                sub_founds.unshift(1); // <- nuke the parent node out of the list
                sub_founds.unshift(j); // <- position to insert the subresult

                founds.splice.apply(founds, sub_founds);

                j += sub_founds.length - 3;
              }`

          founds = uniq(founds) if rule.length > 1
          return founds

      return tokens_cache[rule_key]


    #
    # Builds the list of selectors for the css_rule
    #
    # @param {String} raw css-rule
    # @return {Array} of selectors
    #
    selectors_cache = {};
    split_rule_to_selectors = (css_rule)->
      unless selectors_cache[css_rule]
        chunker.lastIndex = 0

        rules = []; rule = []; rel = ' '; token=null
        while m = chunker.exec(css_rule)
          token = m[1]

          if token in ['+', '>', '~']
            rel = token
          else
            rule.push([rel, token])
            rel = ' '

          if m[2]
            rules.push(build_selector(rule))
            rule = []

        rules.push(build_selector(rule))

        selectors_cache[css_rule] = rules

      return selectors_cache[css_rule]


    #
    # The top level method, it just goes throught the css-rule chunks
    # collect and merge the results that's it
    #
    # @param {HTMLElement} context
    # @param {String} raw css-rule
    # @return {Array} search result
    #
    select_all = (element, css_rule)->
      result = []
      for selector in split_rule_to_selectors(css_rule)
        result = result.concat(selector(element))

      return result


  ###############################################################################
  ###############################################################################
  ###############################################################################

    # the dom-selection methods replacement
    return {
      first: (css_rule)->
        @find(css_rule)[0]

      find: (css_rule, raw)->
        rule = css_rule || '*'; element = @_; tag = element.tagName;

        try # trying to reuse native css-engine under IE8
          result = (element for element in element.querySelectorAll(rule))
        catch e # if it fails use our own engine
          result = select_all(element, rule)

        if raw is true then result else new Search(result)
    }
