mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

schema = new Schema
  name: String
  email: String
  text: String
  createdAt : { type: Date, "default": Date.now }
  updatedAt : { type: Date, "default": Date.now }
,
  strict: false
  versionKey: false

schema.pre "save", (next) ->
  for k,v of @._doc
    delete @._doc[k] if v == null
  
  date = new Date
  @updatedAt = date 
  @createdAt = @updatedAt unless @createdAt
  next()

module.exports = schema