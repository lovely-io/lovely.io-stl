#
# The packages repositry handlers
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Returns a hash of all the packages and their versions
# currently installed in the system
#
# @return {Object} list
#
exports.list = ->
  fs   = require('fs')
  list = {}

  location = lovelyrc.base
  location[location.length - 1] == '/' || (location += '/')
  location+= "packages/"

  for name in fs.readdirSync(location)
    if fs.statSync(location + name).isDirectory()
      versions = []
      for version in fs.readdirSync(location + name)
        unless version is 'current'
          versions.push(version)

      list[name] = versions.sort().reverse().slice(1)

  list


#
# Saves the package in the repository
#
# @param {Object} package manifest
# @param {String} build
#
exports.save = (package, build)->
  location = lovelyrc.base
  location[location.length - 1] == '/' || (location += '/')
  location += "packages/#{package.name}/#{package.version}"

  system "rm -rf #{location}", ->
    system "mkdir -p #{location}", ->
      fs = require('fs')

      fs.mkdirSync("#{location}/images", 0755)
      build = build.replace /('|")([^'"]+\.(gif|png|jpg|jpeg|svg|swf))\1/g,
      (match, q, url)->
        if url.indexOf('http://') > -1
          url = url.replace(/http:\/\/[^\/]+/, '')

          do (url)->
            # downloading the image
            require('../hosting').download url,
              "#{location}/images/#{url.replace(/^\/[^\/]+\/[^\/]+\//, '')}"

          url = "images/#{url.replace(/^\/[^\/]+\/[^\/]+\//, '')}"

        else
          # copying over a local file
          url = url.replace(/^\//, '')
          fs.writeFileSync("#{location}/#{url}", fs.readFileSync("#{process.cwd()}/#{url}"))

        "#{q}/#{package.name}/#{package.version}/#{url}#{q}"

      fs.writeFileSync("#{location}/build.js", build)
      fs.writeFileSync("#{location}/package.json", JSON.stringify(package))

      system "#{__dirname}/../bin/lovely activate #{package.name}"
