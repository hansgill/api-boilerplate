#
# Module dependencies.
#
vm = require 'vm'
fs = require 'fs'
util = require 'util'

appRoute = "app.js"

bootstrapRouteFolder = (dir, app) ->
  # grab a list of our route files
  fs.readdirSync(dir).forEach( (file) ->
    path = dir + '/' + file
    stats = fs.lstatSync path
    #recurse into sub directories
    if stats.isDirectory()
      return bootstrapRouteFolder path, app

    require(path) app if file isnt appRoute
  )


module.exports = (app) ->
  dir = __dirname + '/routes'
  # bootstrap all routes except for browser app
  bootstrapRouteFolder dir, app
  
  # finally boot the browser routes, which will match everything else
  require("#{dir}/#{appRoute}") app
