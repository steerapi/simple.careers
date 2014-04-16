'use strict';

passport = require("passport")
mongoose = require("mongoose")
User = mongoose.model("user")
LinkedInStrategy = require('passport-linkedin').Strategy;

linkedin = {}

hat = require "hat"

passport.use new LinkedInStrategy
  consumerKey: "77ht645nr4wfov"
  consumerSecret: "f9uP5fCD1wuWBXJ2"
  callbackURL: "/auth/linkedin/callback"
  profileFields: [ 'id',
  'first-name',
  'last-name',
  'email-address',
  'headline',
  'industry',
  'skills',
  'certifications',
  'educations',
  'courses',
  'volunteer',
  'honors-awards',
  'recommendations-received',
  'num-recommenders',
  'three-current-positions',
  'three-past-positions',
  'site-standard-profile-request',
  'picture-url',
  'positions',
  'specialties',
  'summary',
  'location',
  'public-profile-url',
  'associations',
  'interests',
  'publications',
  'patents',
  'languages',
  'job-bookmarks',
  'suggestions',
  'date-of-birth',
  'member-url-resources' ]
  
, (token, tokenSecret, profile, done) ->
  delete profile._raw
  # delete profile._json
  User.find
    "linkedin.profile.id": profile.id
  , (err, users) ->
    obj = 
      username: profile._json.emailAddress or hat(8)
      password: hat(8)
      email: profile._json.emailAddress
      provider: "linkedin"
      name: profile.displayName
      token: hat()
      linkedin:
        profile: profile
        token: token
        tokenSecret: tokenSecret
    if not users or users.length == 0
      User.create obj, (err, user) ->
        done err, user
    else
      user = users[0]
      User.update 
        _id: user._id
      , obj
      , (err, num, raw) ->
        User.findOne
          _id: user._id
        , (err, user) ->
          done err, user
  return


# GET /auth/linkedin
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  The first step in LinkedIn authentication will involve
#   redirecting the user to linkedin.com.  After authorization, LinkedIn will
#   redirect the user back to this application at /auth/linkedin/callback
linkedin.auth = (req, res) ->
  req.session.redirect = req.query.redirect
  req.session["apply"] = req.query["apply"]
  ln = passport.authenticate("linkedin", { scope: ['r_fullprofile', 'r_emailaddress'] })
  ln(req,res,->)

# GET /auth/linkedin/callback
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be redirected back to the
#   login page.  Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
linkedin.callback = (req, res) ->
  userId = req.session.passport.user
  User.findOne _id:userId, (err,user)->
    user = JSON.parse JSON.stringify user    
    if req.session["apply"]
      UserApply.create
        user: user._id
        job: req.session["apply"]
      , (err,userapply)->
    res.redirect "/app/?userId=#{user._id}&token=#{user.token}&redirect=#{req.session.redirect}"
    return
  return
  
module.exports = linkedin