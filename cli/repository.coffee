#
# The packages repositry handlers
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#

#
# Returns a hash of all the packages and their versions
# currently installed in the system
#
# @return {Object} list
#
exports.list = ->
  fs       = require('fs')
  lovelyrc = require('./lovelyrc')
  location = lovelyrc.base + "/packages/"
  list     = {}

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
exports.save = (pack, build)->
  lovelyrc = require('./lovelyrc')
  location = lovelyrc.base + "/packages/#{pack.name}/#{pack.version}"

  system "rm -rf #{location}", ->
    system "mkdir -p #{location}", ->
      fs = require('fs')

      fs.mkdirSync("#{location}/images", 0o0755)
      build = build.replace /('|")(([^'"]+\.(gif|png|jpg|jpeg|svg|swf|eot|ttf|woff))|(\/assets\/[a-z0-9]+))\1/g,
      (match, q, url)->
        if url.indexOf('http://') > -1 or url.indexOf('/assets/') is 0
          url = url.replace(/http:\/\/[^\/]+/, '')

          do (url)->
            # downloading the image
            require('./hosting').download url,
              "#{location}/images/#{url.replace(/^\/[^\/]+\/[^\/]+\//, '').replace('/assets/', '')}"

          url = "images/#{url.replace(/^\/[^\/]+\/[^\/]+\//, '').replace('/assets/', '')}"

        else
          # copying over a local file
          url = url.replace(/^\//, '')
          fs.writeFileSync("#{location}/#{url}", fs.readFileSync("#{process.cwd()}/#{url}"))

        "#{q}/#{pack.name}/#{pack.version}/#{url}#{q}"

      fs.writeFileSync("#{location}/build.js", build)
      fs.writeFileSync("#{location}/package.json", JSON.stringify(pack))

      system "#{__dirname}/../bin/lovely activate #{pack.name}"
