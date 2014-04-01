mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

schema = new Schema
  companyname: String
  companytagline: String
  joblocation: String
  picture: String
  jobtagline: String
  positionname: String
  yrsofexperience: String
  skills: [String]
  worktypes: [String]
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