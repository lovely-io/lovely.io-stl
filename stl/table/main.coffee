#
# Tables main file
#
# Copyright (C) 2013 Nikolay Nemshilov
#

core    = require('core')
$       = require('dom')


ext     = core.ext
Class   = core.Class
Element = $.Element

include 'src/table'

$.Wrapper.set 'table', Table

$(document).delegate 'table th[data-sort]', 'click', ->
  @parent('table').sort(@index(), !@hasClass('asc'))

exports = ext Table,
  version: '%{version}'
