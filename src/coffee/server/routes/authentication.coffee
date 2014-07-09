fs              = require 'fs'
express         = require "express"
url             = require "url"
sysutils        = require '../../shared/sysutils'
async           = require "async"
conf            = require "../../shared/conf"
http            = require 'http'
passport        = require 'passport'
basicAuth       = require 'basic-auth'
BearerStrategy  = require("passport-http-bearer").Strategy
{User}            = require "../../shared/models/user"

############################################################################
# authentication routes
# Sets up basic authentication and protects the /api/* routes with a token
############################################################################

module.exports = (app) ->

  #token based authentication setup
  passport.use new BearerStrategy {} ,(token, done)->
    process.nextTick ()->
      #find user via token
      data =
        accessToken : token
      User.authenticateAccessToken data, (err,user)->
        #if user is not found return false
        return done(null, false) if err
        console.dir "user authenticated"
        #return user and this api call is validated.
        return done(null, user)

  if conf.get("protectAPI")
    #make sure all the api calls are authenticated with a user token
    app.all "/api/*", passport.authenticate('bearer', { session: false })

  if conf.get("enableBasicAuth")
    auth = (req, res, next)->
      user = basicAuth req
      console.dir "authentication login"
      console.dir user
      #find user and based on email and password.
      #we should also update the users token to be a new token. This makes sure
      #that someone can't just steal a users token. However this also means the user can
      #only be logged in to one device at any given time, since a call to login would automatically
      #override the last accessToken.
      data =
        email : user?.name
        password: user?.pass

      User.authenticateUserPassword data, (err,user)->
        if err
          res.set('WWW-Authenticate', 'Basic realm=Authorization Required')
          return res.send(401)
        #add user to the request so it can be used in rest of the chain
        req.user = user
        return next()

    app.get "/auth/login", auth, (req,res)->
      #req.user should be populated via auth method above
      res.send req.user

    #this is similar to session initialization. The client will send us an accessToken
    #if we find a user associated with that token, the user object is sent back to the client
    app.get "/auth/user/token", passport.authenticate('bearer', {session:false}), (req,res)->
      console.dir "auth/user/token"
      #req.user should be populated via auth method above
      res.send req.user

    app.get "/auth/logout", (req,res)->
      console.log "logout"
      res.redirect "/"