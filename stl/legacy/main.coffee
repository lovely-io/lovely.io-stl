#
# Legacy main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

core     = Lovely
dom      = Lovely.modules.__dom
window   = global
document = global.document
Document = dom.Document
Element  = dom.Element
uid      = dom.uid
ext      = Lovely.ext
List     = Lovely.List
$        = dom

# checking if it's IE < 9
try
  document.createElement('<input/>')
  BROWSER_IS_OLD_IE = true
catch e
  BROWSER_IS_OLD_IE = false


include 'src/formio'
include 'src/search'
include 'src/element'
include 'src/document'

# exporting
exports.version = '%{version}'