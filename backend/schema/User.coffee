mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

schema = new Schema
  name: String
  school: String
  year: String
  degree: String
  major: String
  resume: String
  picture: String
  tagline: String
  skills: [String]
  worktypes: [String]
  github: String
  linkedin: String
  website: String
  type: String
  createdAt : { type: Date, "default": Date.now }
  updatedAt : { type: Date, "default": Date.now }
,
  strict: false
  versionKey: false

passportLocalMongoose = require('passport-local-mongoose')
schema.plugin(passportLocalMongoose)

schema.pre "save", (next) ->
  for k,v of @._doc
    delete @._doc[k] if v == null
  
  date = new Date
  @updatedAt = date 
  @createdAt = @updatedAt unless @createdAt
  next()

module.exports = schema