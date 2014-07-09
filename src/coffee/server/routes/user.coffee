util        = require "util"
conf        = require "../../shared/conf"
{User}  = require "../../shared/models/user"

module.exports = (app) ->
  
  app.get "/api/users/:id", (req,res)->
    User.getUser {_id:req.params.id}, (err,user)->
      console.dir user
      res.send user



