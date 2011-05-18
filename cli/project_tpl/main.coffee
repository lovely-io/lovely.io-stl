#
# %{projectname} main file
#
# Copyright (C) %{year} %{username}
#

# hook up dependencies
var core = require('core')
var dom  = require('dom')

# glue in your files
include 'src/my_file'

# export your objects
exports.version = '%{version}'