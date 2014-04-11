mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
findOrCreate = require('mongoose-findorcreate')

schema = new Schema
  createdAt : { type: Date, "default": Date.now }
  updatedAt : { type: Date, "default": Date.now }
,
  strict: false
  versionKey: false

# passportLocalMongoose = require('passport-local-mongoose')
# schema.plugin(passportLocalMongoose)
# schema.plugin(findOrCreate)

schema.pre "save", (next) ->
  for k,v of @._doc
    delete @._doc[k] if v == null
  
  date = new Date
  @updatedAt = date 
  @createdAt = @updatedAt unless @createdAt
  next()

module.exports = schema