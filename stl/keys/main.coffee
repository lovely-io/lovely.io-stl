#
# Keys main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')

# glue in the files
include 'src/keys'


exports.version = '%{version}'