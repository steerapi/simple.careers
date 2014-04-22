mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

schema = new Schema
  createdAt : { type: Date, "default": Date.now }
  updatedAt : { type: Date, "default": Date.now }
  user: { type: ObjectId, ref: 'user' }
  job: { type: ObjectId, ref: 'job' }
,
  strict: false
  versionKey: false

schema.index({ user: 1, job: 1 }, { unique: true })

# passportLocalMongoose = require('passport-local-mongoose')
# schema.plugin(passportLocalMongoose)

schema.pre "save", (next) ->
  date = new Date
  @updatedAt = date 
  @createdAt = @updatedAt unless @createdAt
  next()

module.exports = schema