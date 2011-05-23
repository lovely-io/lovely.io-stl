#
# Replacing the `Document` unit search methods
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hooking up the manual CSS-search engine
if Search_module
  Document.prototype.first = Search_module.first
  Document.prototype.find  = Search_module.find