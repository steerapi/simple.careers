'use strict';

passport = require "passport"
mongoose = require("mongoose")
User = mongoose.model("user")
FacebookStrategy = require('passport-facebook').Strategy;

facebook = {}

hat = require "hat"

passport.use new FacebookStrategy
  clientID: "1484996168383259"
  clientSecret: "fa2767a85d9ec01a4f56fa336dac6578"
  callbackURL: "/auth/facebook/callback"
  enableProof: false
, (accessToken, refreshToken, profile, done) ->
  #TODO
  done "Not Implemented"

facebook.auth = (req, res)->
  req.session.redirect = req.query.redirect
  fb = passport.authenticate("facebook")
  fb req,res,->   

facebook.callback = (req, res) ->
  userId = req.session.passport.user
  User.findOne _id:userId, (err,user)->
    user = JSON.parse JSON.stringify user
    res.redirect "/app/?userId=#{user._id}&token=#{user.token}&redirect=#{req.session.redirect}"
    return
  return
  
module.exports = facebook