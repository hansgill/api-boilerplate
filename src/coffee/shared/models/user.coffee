mongoose    = require "mongoose"
Schema      = mongoose.Schema
_           = require "underscore"
async       = require "async"
sysutils    = require '../sysutils'
conf = require "../conf"
uuid = require "node-uuid"
bcrypt = require "bcrypt"
_ = require 'underscore'
#modelContext = require './model-context'

getModel = (name) ->
  ###
  Dynamically pulls the _Mongoose Model_, useful if you want to reference a _function_ declared
  as a `methods` or `statics` instance within another `method` or `static` function declaration.
  ###
  mongoose.model name
# User document
User = new Schema
  firstName:
    type: String
  lastName:
    type: String
  email:
    type: String
  password:
    type: String
  accessToken:
    type: String

User.virtual('id').get () ->
  return this._id.toHexString()

User.statics.sanitizeUser = (user)->

  return _.omit user, ['password']

User.statics.getUser = (data, callback)->
  @findOne {id:data.id}, (err,user)->
    return callback err, user

#find the user by email. Once the user is found check the password using bCrypt.
User.statics.authenticateUserPassword = (data, callback)->
  getModel("User").findOne {email:data.email}, (err,user)->
    if not user
      console.dir "User not found"
      return callback
        message : "Incorrect email or password"
        code    : 1
    bcrypt.compare data.password, user.password, (err, match)->
      console.dir "verifying users password"
      if not match
        console.dir "password does not match"
        return callback
          message   : "Incorrect email or password"
          code      : 1
      return callback null, getModel("User").sanitizeUser user.toJSON()

User.statics.authenticateAccessToken = (data, callback)->
  getModel("User").findOne {accessToken:data.accessToken}, (err,user)->
    if not user
      return callback
        message : "Invalid Access Token"
        code    : 2
    return callback null, getModel("User").sanitizeUser user.toJSON()

# register model
mongoose.model('User', User)

# and export the model
module.exports.User = mongoose.model 'User'
