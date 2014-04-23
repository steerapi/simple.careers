"use strict"
mongoose = require("mongoose")
User = mongoose.model("user")
passport = require("passport")
LocalStrategy = require("passport-local").Strategy
BearerStrategy = require("passport-http-bearer").Strategy
# BasicStrategy = require("passport-http").BasicStrategy


# config = require("../config/config")
hat = require "hat"

###
Passport configuration
###
passport.serializeUser (user, done) ->
  done null, user.id
  return

passport.deserializeUser (id, done) ->
  # if id==config.annotate.username
  #   done null, {id:username}
  #   return
  User.findOne
    _id: id
  , "-salt -hashedPassword", (err, user) -> # don't ever give out the password or salt
    done err, user
    return

  return


# add other strategies for more authentication flexibility
passport.use new LocalStrategy(
  usernameField: "email"
  passwordField: "password" # this is the virtual field on the model
, (email, password, done) ->
  User.findOne
    email: email
  , (err, user) ->
    return done(err)  if err
    unless user
      return done(null, false,
        message: "This email is not registered."
      )
    unless user.authenticate(password)
      return done(null, false,
        message: "This password is not correct."
      )
    done null, user

  return
)

passport.use new BearerStrategy((token, done) ->
  if token=="5168fb941960bec6afaa7b23f2d0fa92"
    done null, id:"annotate"
    return
  User.findOne
    token: token
  , (err, user) ->
    return done(err)  if err
    return done(null, false)  unless user
    done null, user,
      scope: "all"
  return
)

# passport.use new BasicStrategy((username, password, done) ->
#   # console.log username
#   # console.log password
#   # console.log config.annotate.username
#   # console.log config.annotate.password
#   if (username==config.annotate.username) && (password == config.annotate.password)
#     done null, {id:username}
#   else
#     done "invalid"
#   return
# )

module.exports = passport