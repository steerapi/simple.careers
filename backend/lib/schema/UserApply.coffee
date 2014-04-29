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

config = require "../config/config"
mandrill = require("mandrill-api")

sendMail = (user,job,cb)->
  # Send the email!
  m = new mandrill.Mandrill(config.mandrill)
  params = 
    message:
      from_email: "hello@simple.careers"
      to: [email: "hello@simple.careers"]
      subject: "New Application."
      text: """Hi Simple.Careers, 
      
      There is a new application for you.
      #{user.name}
      #{user.email}
      
      Apply to
      #{job.position}
      #{job.companyname}
      
      """
  m.call "/messages/send", params, (res) ->
    cb? null,res
  , (err) ->
    cb? err
    
schema.pre "save", (next) ->
  User = mongoose.model("user")
  Job = mongoose.model("job")
  
  User.findById @._doc["user"], (err,user)=>
    Job.findById @._doc["job"], (err,job)=>
      sendMail user,job
  
  date = new Date
  @updatedAt = date 
  @createdAt = @updatedAt unless @createdAt
  next()

module.exports = schema