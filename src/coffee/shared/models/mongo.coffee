conf = require "../../shared/conf"
util = require "util"
mongoose = require "mongoose"

# connect to db
connCb = (err) ->
  if err
    return console.log "#{conf.get("app_id")}: Error connecting to Mongo - " + err
  console.log "#{conf.get("app_id")}: Connected API to Mongo"

env = conf.get "NODE_ENV"
mongo = conf.get "mongo"
app_name = conf.get("app_id")
db_name_suffix = ""
db_name_suffix = "-#{env}" unless env == "prod" || env == "production"
database = "#{app_name}#{db_name_suffix}"
console.log "MongoDB Database set to #{database}.".blue

if mongo?.hosts?.length > 0
  _mongoConnStr = mongo.hosts.map( (x) ->
    return util.format "mongodb://%s/%s", x, database
  ).join(",")
  mongoose.connect _mongoConnStr, connCb
  console.log "MongoDB hosts set to #{mongo.hosts}.".blue
else if mongo.host
  mongoose.connect util.format("mongodb://%s/%s", mongo.host, database), connCb
  console.log "MongoDB hosts set to #{mongo.host}.".blue
else
  throw new Error "MongodDB Connection is not initialized, host(s) went AWOL."
