###
* Copyright (c) 2011 Hans Gill. All rights reserved. Copyrights licensed under the MIT License.
* See LICENSE file included with this code project for license terms.
###
sys      = require 'sys'
conf = require "./conf"


class DateHelper

  currentYearAndWeek : () ->
    @getYearAndWeek()

helper = module.exports =
  mongoArrayToJSON: (docArray)->
    res = []
    docArray.forEach( (doc)-> res.push(doc.toJSON()))
    res
  
  randomInt: (max)->
    Math.floor(Math.random()*max)
