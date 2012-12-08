#
# Package files parser/validator
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#


#
# Validates the package content
#
# @param {Object} data
#
validate = (data) ->
  errors = [];

  data.name        || errors.push("miss the 'name' field")
  data.version     || errors.push("miss the 'version' field")
  data.description || errors.push("miss the 'description' field")
  data.author      || errors.push("miss the 'author' field")
  data.license     || errors.push("miss the 'license' field")

  data.version.match(/^\d+\.\d+\.\d+$/) ||
    errors.push("'version' should match the '\d+.\d+.\d+' format")

  if errors.length
    print "Failed to parse the 'package.json' file:\n".red +
      errors.join("\n");
    process.exit()

#
# Reads the package data out fo the given dreictory
#
exports.read = read = (directory) ->
  fs          = require('fs')
  directory or= process.cwd()

  for name in ['lovely', 'package']
    if fs.existsSync("#{directory}/#{name}.json")
      data = fs.readFileSync("#{directory}/#{name}.json")
      data = JSON.parse(data.toString())

  data && validate(data)
  data

#
# Parsing the current package
#
try
  for key, value of read()
    exports[key] = value

catch e
  # file does not exists