mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

schema = new Schema
  picture: {
    # url: String
    # filename: String
    # mimetype: String
    # size: String
  }
  logo: {
    # url: String
    # filename: String
    # mimetype: String
    # size: String
  }
  type: String
  companyname: String
  companytagline: String
  location: String
  jobtagline: String
  position: String
  badges: [ {
    # url: String
    # filename: String
    # mimetype: String
    # size: String
  } ]
  worktype: String
  order: Number
  
  source: String
  
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