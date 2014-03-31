mongoose = require "mongoose"
bcrypt = require "bcrypt"
SALT_WORK_FACTOR = 10

Schema = mongoose.Schema
ObjectId = Schema.ObjectId;

schema = new Schema {
  canCreateFair: Boolean
  token: String
  resetToken: String
  username: { type: String, index: {unique: true} }
  password: String
  type: String
  student: { type: ObjectId, ref: 'student' }
  organizer: { type: ObjectId, ref: 'organizer' } # Note: to remove
  employer: { type: ObjectId, ref: 'employer' } # Note: to remove
  createdAt : { type: Date, "default": Date.now }
  updatedAt : { type: Date, "default": Date.now }
} , { 
  strict: false
  versionKey: false
}

passportLocalMongoose = require('passport-local-mongoose')
schema.plugin(passportLocalMongoose)

# irreversibly encrypt password using bcrypt before saving to database
schema.pre "save", (next) ->
  for k,v of @._doc
    delete @._doc[k] if v == null

  date = new Date
  @updatedAt = date 
  @createdAt = @updatedAt unless @createdAt

  user = this
    
  # do nothing if password is not modified
  unless user.isModified "password"
    return next()

  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    if err 
        return next()
        
    bcrypt.hash user.password, salt, (err, hash) ->
      if err 
          return next(err)
      user.password = hash
      next()
        
# compare passwords by comparing the encrypted versions
schema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, this.password, (err, isMatch) ->
    if err 
        return cb(err)
    return cb(null, isMatch)



module.exports = schema