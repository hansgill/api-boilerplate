util = require "util"
conf = require "../../shared/conf"

module.exports = (app) ->
  
  app.get '/health', (req, res) ->
    res.send {}

  app.use (req,res)->
    res.render "index"

