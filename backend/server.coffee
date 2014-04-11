# process.on 'uncaughtException', (err)->
#   console.log(err)

config = require("./config.coffee")
mandrill = require("mandrill-api")
mongoose = require "mongoose"
mongooseCachebox = require "mongoose-cachebox"
options =
  cache: true # start caching
  ttl: 30 # 30 seconds
hat = require('hat')

mongooseCachebox mongoose, options
mongoose.connect config.mongo

# Web version
db = mongoose.connection
db.on "error", ->
  console.log arguments...
db.once "open", ->
  console.log arguments...

express = require "express"
Schema = require "./schema"
en = require('lingo').en
  
# Register the schemata and retrieve user database
Models = {}
Schema.list.forEach (item)->
  Models[item] = mongoose.model item.toLowerCase(), Schema[item]

User = Models["User"]
Askus = Models["Askus"]


# Create the app and listen for API requests
app = express()
app.use(express.basicAuth('simple', 'simple1337'));
app.use(express.static(__dirname + '/../frontend/dist'));
app.use("/pages",express.static(__dirname + '/../frontend/pages'));

app.use(express.logger());
app.use(express.cookieParser());
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.session({ secret: 'joyce1331' }));

passport = require 'passport'
LinkedInStrategy = require('passport-linkedin').Strategy;
# Init passport
app.use(passport.initialize());
app.use(passport.session());

passport.use new LinkedInStrategy(
  consumerKey: "77ht645nr4wfov"
  consumerSecret: "f9uP5fCD1wuWBXJ2"
  callbackURL: "/auth/linkedin/callback"
  profileFields: ['id', 'first-name', 'last-name', 'email-address', 'headline', "industry", "skills", "certifications", "educations", "courses", "volunteer", "honors-awards", "recommendations-received", "num-recommenders", "three-current-positions", "three-past-positions", "site-standard-profile-request", "picture-url", "positions", "specialties", "summary"]
, (token, tokenSecret, profile, done) ->
  delete profile._raw
  # delete profile._json
  User.find
    "_linkedin.profile.id": profile.id
  , (err, users) ->
    obj = 
      token: hat()
      _linkedin:
        profile: profile
        token: token
        tokenSecret: tokenSecret
    if not users or users.length == 0
      User.create obj
      , (err, users) ->
        done err, users[0]
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
)

# use static authenticate method of model in LocalStrategy
# passport.use(User.createStrategy());
# use static serialize and deserialize of model for passport session support
# passport.serializeUser User.serializeUser()
# passport.deserializeUser User.deserializeUser()

passport.serializeUser (user, done) ->
  done null, user
  return

passport.deserializeUser (obj, done) ->
  done null, obj
  return

ensureAuth = (request, response, next) ->
  console.log "ensureAuth"
  return next()  if request.isAuthenticated()
  response.send 401

sendConfirmToken = (to, token, cb)->

  # Send the email!
  m = new mandrill.Mandrill(config.mandrill)
  params = 
    message:
      from_email: "support@simple.careers"
      to: [email: to]
      subject: "Welcome to Simple Careers - User account verification."
      text: """Hi #{to}, 

      Your new user account with the email address #{to} is now set up. 

      Please use the link below to activate your account. 
      http://www.simple.careers/auth/v1/verification/#{token}

      If you have not requested the creation of a Simple Careers account, or if you think this is an unauthorized use of your email address, please contact us at support@simple.careers. 

      """
  m.call "/messages/send", params, (res) ->
    cb null,res
  , (err) ->
    cb err

# sendConfirmToken "steerapi@gmail.com", "testtoken", ->
#   console.log arguments...

app.get "/auth/v1/protected", ensureAuth, (req, res) ->
  res.send "You are in."

app.get "/auth/v1/login", (req, res) ->
  res.send 401

app.post "/auth/v1/resend", (req, res) ->
  User.findByUsername req.body.username, (err, user) ->
    if(user)
      require('crypto').randomBytes 48, (ex, buf)->
        token = buf.toString('hex')
        user.set "token", token
        user.save (err, user)->
          console.log arguments...
          res.send 401 if err          
          sendConfirmToken req.body.username, token, (err, json) ->
            res.send 401 if err
            console.log "err: ",err
            console.log "json: ",json
            res.send 200
    else
      res.send 401

app.get "/auth/v1/verification/:token", (req, res) ->
  token = req.params.token
  User.findOne {token: token}, (err, user) ->
    if(user)
      user.set "verified", true
      user.save ->
        res.redirect('http://www.simple.careers/pages/verified.html');
        # res.send "Your account is verified. Please download Simple on the App Store."
    else
      res.redirect('http://www.simple.careers/pages/denied.html');
      # res.send "We're sorry. The code does not match."

# app.post "/auth/v1/login", passport.authenticate("local",
#   failureRedirect: "/auth/v1/login"
# ), (req, res) ->

app.post "/auth/v1/login", passport.authenticate("local"), (req, res) ->
  # Auth success
  if not req.body
    res.send 400
    return
  if not req.body.username
    res.send 400
    return
  if not req.body.password
    res.send 400
    return
  User.findByUsername req.body.username, (err, user) ->
    if(user)
      # res.send
      #   userid: user.get "_id"
      #   verified: true
      # Filter for wellesley
      username = user.get "username"
      # if username=="guest@simple.careers" or username.match(/wellesley.edu/gi)
      res.send
        userid: user.get "_id"
        verified: true
        # verified: user.get "verified"
      # else
        # res.send 401
    else
      res.send 401
      # require('crypto').randomBytes 48, (ex, buf)->
      #   token = buf.toString('hex')
      #   req.body.token = token
      #   User.create req.body, (err, user)->
      #     if err
      #       res.send 400, err
      #       return
      #     sendConfirmToken req.body.username, token, (err,json)-> 
      #       # return res.send 401 if err
      #       res.send 
      #         verified: true
      #         userid: user.get "_id"
      # res.send 401

app.post "/auth/v1/signup", (req, res) ->
  # Auth success
  if not req.body
    res.send 400
    return
  if not req.body.username
    res.send 400
    return
  if not req.body.password
    res.send 400
    return
  require('crypto').randomBytes 48, (ex, buf)->
    token = buf.toString('hex')
    req.body.token = token
    User.register new User({ username : req.body.username }), req.body.password, (err)->
      if err
        res.send 400, err
        return
      sendConfirmToken req.body.username, token, (err,json)-> 
        # return res.send 401 if err
        console.log "err: ",err
        console.log "json: ",json
        res.send 200

app.get "/auth/v1/logout", (req, res) ->
  req.logout()
  res.send 200

sendAskus = (fromName, fromEmail, message, cb)->
  # Send the email!
  m = new mandrill.Mandrill(config.mandrill)
  params = 
    message:
      from_email: "#{fromEmail}"
      to: [email: "support@simple.careers"]
      subject: "Askus from #{fromName}"
      text: message
  m.call "/messages/send", params, (res) ->
    cb null,res
  , (err) ->
    cb err
  
app.post "/askus", (req, res) ->
  # Auth success
  Askus.create req.body, ->
    res.send 200
    sendAskus req.body.name, req.body.email, req.body.text, ->

## Reset Password

sendResetPassword = (to, token, cb)->
  # Send the email!
  m = new mandrill.Mandrill(config.mandrill)
  params = 
    message:
      from_email: "support@simple.careers"
      to: [email: to]
      subject: "Simple Careers - Password Reset."
      text: """Hi #{to}, 

      You have request a password reset for your email address #{to}. 

      Please use the link below to reset your password. 
      http://www.simple.careers/auth/v1/reset/#{token}

      If you have not requested the password reset of your Simple Careers account, or if you think this is an unauthorized use of your email address, please contact us at support@simple.careers. 

      """
  m.call "/messages/send", params, (res) ->
    cb null,res
  , (err) ->
    cb err
    

sendConfirmResetPassword = (to, cb)->
  # Send the email!
  m = new mandrill.Mandrill(config.mandrill)
  params = 
    message:
      from_email: "support@simple.careers"
      to: [email: to]
      subject: "Simple Careers - Password Reset."
      text: """Hi #{to}, 

      Your password has been reset. 

      If you think this is an unauthorized use of your email address, please contact us at support@simple.careers. 

      """
  m.call "/messages/send", params, (res) ->
    cb null,res
  , (err) ->
    cb err

app.get "/auth/v1/reset/:token", (req, res) ->
  token = req.params.token
  User.findOne {resetToken: token}, (err, user) ->
    (res.send 401; return) if err
    if(user)
      user.set "verified", true
      user.save ->
        res.redirect("http://www.simple.careers/pages/reset.html?token=#{token}");
    else
      res.redirect("http://www.simple.careers/pages/resetdenied.html");

app.post "/auth/v1/setpass", (req, res) ->
  token = req.body.token
  password = req.body.password
  (res.send 401; return) if not token
  User.findOne {resetToken: token}, (err, user) ->
    user.setPassword password, ->
      require('crypto').randomBytes 48, (err, buf)->
        (res.send 401; return) if err
        newtoken = buf.toString('hex')
        user.set "resetToken", newtoken
        user.save (err)->
          (res.send 401; return) if err
          sendConfirmResetPassword user.username, (err)->
            (res.send 401; return) if err
            res.send 200

app.post "/auth/v1/reset", (req, res) ->
  (res.send 401; return) if not req.body.email
  User.findByUsername req.body.email, (err, user) ->
    (res.send 401; return) if err or not user
    require('crypto').randomBytes 48, (err, buf)->
      (res.send 401; return) if err
      token = buf.toString('hex')
      user.set "resetToken", token
      user.save (err)->
        (res.send 401; return) if err
        sendResetPassword req.body.email, token, (err,json)->
          (res.send 401; return) if err
          res.send 200

# Setup PORT
port = process.env.PORT || 8080

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  return

app.configure "production", ->
  app.use express.errorHandler()
  return


# GET /auth/linkedin
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  The first step in LinkedIn authentication will involve
#   redirecting the user to linkedin.com.  After authorization, LinkedIn will
#   redirect the user back to this application at /auth/linkedin/callback
app.get "/auth/linkedin", passport.authenticate("linkedin", { scope: ['r_fullprofile', 'r_emailaddress'] }), (req, res) ->
# The request will be redirected to LinkedIn for authentication, so this
# function will not be called.

# GET /auth/linkedin/callback
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be redirected back to the
#   login page.  Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
app.get "/auth/linkedin/callback", passport.authenticate("linkedin",
  failureRedirect: "/auth/linkedin"
), (req, res) ->
  user = req.session.passport.user
  User.findOne _id:user._id, (err,user)->
    user = JSON.parse JSON.stringify user
    res.redirect "/?userId=#{user._id}&token=#{user.token}"
    return
  return

app.get "/logout", (req, res) ->
  req.logout()
  res.redirect "/"
  return

# Listening
app.listen port
console.log "Listening on #{port}"
