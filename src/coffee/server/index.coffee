#
# Module dependencies.
#
express         = require 'express'
connect         = require 'connect'
session         = require 'express-session'
bodyParser      = require 'body-parser'
methodOverride  = require 'method-override'
cookieParser    = require 'cookie-parser'
errorHandler    = require 'errorhandler'
conf        = require "../shared/conf"
app         = express()
server      = require('http').createServer app
#MongoStore  = require('connect-mongo')(express)
cons        = require("consolidate")
passport    = require "passport"
cors        = require "cors"


app.engine '.html', cons.ejs
app.engine '.json', cons.ejs
app.set 'views', __dirname + '/views'
app.set 'view engine', 'html'
app.use cors()
app.use passport.initialize()
app.use bodyParser()
app.use methodOverride()
app.use express.static __dirname + '/public'
app.use cookieParser()
###app.use session
  secret: 'hackathon'
  maxAge: new Date(Date.now() + 36000000000)
  store: new MongoStore
    db: 'connect-mongo-store'
    host: 'localhost'
    collection: 'sessions'
  cookie:
    expires: new Date(Date.now() + 36000000000)###

env = process.env.NODE_ENV || 'development'
if env is 'development'
  app.use errorHandler { dumpExceptions: true, showStack: true }

# connect the db
require "../shared/models/mongo"

(require './boot-routes') app

printArt = () ->
  v = conf.get "version"
  console.log "Starting ".green + "#{conf.get "app_id"}".green.italic
  
module.exports =
  start: (callback) ->
    #start server
    server.listen conf.get("port"), () ->
      printArt()
      console.log "#{conf.get "app_id"} app server listening on port %d in %s mode" , conf.get("port"), conf.get("NODE_ENV")
      callback() if callback

  stop: (callback) ->
    #start server
    server.close () ->
      console.log "#{conf.get "app_id"} app server shutting down"
      callback() if callback

