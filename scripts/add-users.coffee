#!/usr/bin/env node

#example of a script you can put in here.
#these scripts must be compiled manually (coffee -c [script-name])

util      = require("util")
mongoose  = require("mongoose")
async     = require("async")
ObjectId  = mongoose.Types.ObjectId
uuid      = require "node-uuid"
bcrypt    = require 'bcrypt'
_         = require 'underscore'

console.log("Bootstrap: Connecting to DB")

# connect to db
connCb = (err)->
  if(err)
    return console.log("Post Install Bootstrap: Error connecting to Mongo - " + err)
  console.log("Bootstrap: Connected API to Mongo")

# setup mongo
db = require("../lib/shared/models/mongo");

# Bootstrap models
User = require("../lib/shared/models/user").User;

users = [
  {
    firstName: "first"
    lastName: "last"
    email: "email@email.com"
    password: "password"
    accessToken: uuid.v1()
  }
]

addUser = (user, callback)->
  bcrypt.genSalt 10, (err, salt)->
    bcrypt.hash user.password, salt, (err, hash)->
      callback err if err
      _.extend user, {password: hash}
      User.update {email:user.email}, {$set:user}, {upsert: true}, (err)->
        callback()

cleanup = ()->
  console.log("Bootstrap: disconnecting from mongo yoooo")
  mongoose.disconnect()

async.forEach users, addUser, (err)->
  cleanup()
