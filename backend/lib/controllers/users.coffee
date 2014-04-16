"use strict"
mongoose = require("mongoose")
User = mongoose.model("user")
passport = require("passport")

###
Create user
###
exports.create = (req, res, next) ->
  newUser = new User(req.body)
  newUser.provider = "local"
  newUser.save (err) ->
    return res.json(400, err)  if err
    req.logIn newUser, (err) ->
      return next(err)  if err
      res.json req.user.userInfo

    return

  return


###
Get profile of specified user
###
exports.show = (req, res, next) ->
  userId = req.params.id
  User.findById userId, (err, user) ->
    return next(err)  if err
    return res.send(404)  unless user
    res.send profile: user.profile
    return

  return


###
Change password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String(req.body.oldPassword)
  newPass = String(req.body.newPassword)
  User.findById userId, (err, user) ->
    if user.authenticate(oldPass)
      user.password = newPass
      user.save (err) ->
        return res.send(400)  if err
        res.send 200
        return

    else
      res.send 403
    return

  return


###
Get current user
###
exports.me = (req, res) ->
  res.json req.user or null
  return

# 
# sendConfirmToken = (to, token, cb)->
# 
#   # Send the email!
#   m = new mandrill.Mandrill(config.mandrill)
#   params = 
#     message:
#       from_email: "support@simple.careers"
#       to: [email: to]
#       subject: "Welcome to Simple Careers - User account verification."
#       text: """Hi #{to}, 
# 
#       Your new user account with the email address #{to} is now set up. 
# 
#       Please use the link below to activate your account. 
#       http://www.simple.careers/auth/v1/verification/#{token}
# 
#       If you have not requested the creation of a Simple Careers account, or if you think this is an unauthorized use of your email address, please contact us at support@simple.careers. 
# 
#       """
#   m.call "/messages/send", params, (res) ->
#     cb null,res
#   , (err) ->
#     cb err
# 
# app.post "/auth/v1/resend", (req, res) ->
#   User.findByUsername req.body.username, (err, user) ->
#     if(user)
#       require('crypto').randomBytes 48, (ex, buf)->
#         token = buf.toString('hex')
#         user.set "token", token
#         user.save (err, user)->
#           console.log arguments...
#           res.send 401 if err          
#           sendConfirmToken req.body.username, token, (err, json) ->
#             res.send 401 if err
#             console.log "err: ",err
#             console.log "json: ",json
#             res.send 200
#     else
#       res.send 401
# 
# app.get "/auth/v1/verification/:token", (req, res) ->
#   token = req.params.token
#   User.findOne {token: token}, (err, user) ->
#     if(user)
#       user.set "verified", true
#       user.save ->
#         res.redirect('http://www.simple.careers/pages/verified.html');
#         # res.send "Your account is verified. Please download Simple on the App Store."
#     else
#       res.redirect('http://www.simple.careers/pages/denied.html');
#       # res.send "We're sorry. The code does not match."
# 
# # app.post "/auth/v1/login", passport.authenticate("local",
# #   failureRedirect: "/auth/v1/login"
# # ), (req, res) ->
# 
# app.post "/auth/v1/login", passport.authenticate("local"), (req, res) ->
#   # Auth success
#   if not req.body
#     res.send 400
#     return
#   if not req.body.username
#     res.send 400
#     return
#   if not req.body.password
#     res.send 400
#     return
#   User.findByUsername req.body.username, (err, user) ->
#     if(user)
#       # res.send
#       #   userid: user.get "_id"
#       #   verified: true
#       # Filter for wellesley
#       username = user.get "username"
#       # if username=="guest@simple.careers" or username.match(/wellesley.edu/gi)
#       res.send
#         userid: user.get "_id"
#         verified: true
#         # verified: user.get "verified"
#       # else
#         # res.send 401
#     else
#       res.send 401
#       # require('crypto').randomBytes 48, (ex, buf)->
#       #   token = buf.toString('hex')
#       #   req.body.token = token
#       #   User.create req.body, (err, user)->
#       #     if err
#       #       res.send 400, err
#       #       return
#       #     sendConfirmToken req.body.username, token, (err,json)-> 
#       #       # return res.send 401 if err
#       #       res.send 
#       #         verified: true
#       #         userid: user.get "_id"
#       # res.send 401
# 
# app.post "/auth/v1/signup", (req, res) ->
#   # Auth success
#   if not req.body
#     res.send 400
#     return
#   if not req.body.username
#     res.send 400
#     return
#   if not req.body.password
#     res.send 400
#     return
#   require('crypto').randomBytes 48, (ex, buf)->
#     token = buf.toString('hex')
#     req.body.token = token
#     User.register new User({ username : req.body.username }), req.body.password, (err)->
#       if err
#         res.send 400, err
#         return
#       sendConfirmToken req.body.username, token, (err,json)-> 
#         # return res.send 401 if err
#         console.log "err: ",err
#         console.log "json: ",json
#         res.send 200
# 

# ## Reset Password
# 
# sendResetPassword = (to, token, cb)->
#   # Send the email!
#   m = new mandrill.Mandrill(config.mandrill)
#   params = 
#     message:
#       from_email: "support@simple.careers"
#       to: [email: to]
#       subject: "Simple Careers - Password Reset."
#       text: """Hi #{to}, 
# 
#       You have request a password reset for your email address #{to}. 
# 
#       Please use the link below to reset your password. 
#       http://www.simple.careers/auth/v1/reset/#{token}
# 
#       If you have not requested the password reset of your Simple Careers account, or if you think this is an unauthorized use of your email address, please contact us at support@simple.careers. 
# 
#       """
#   m.call "/messages/send", params, (res) ->
#     cb null,res
#   , (err) ->
#     cb err
#     
# 
# sendConfirmResetPassword = (to, cb)->
#   # Send the email!
#   m = new mandrill.Mandrill(config.mandrill)
#   params = 
#     message:
#       from_email: "support@simple.careers"
#       to: [email: to]
#       subject: "Simple Careers - Password Reset."
#       text: """Hi #{to}, 
# 
#       Your password has been reset. 
# 
#       If you think this is an unauthorized use of your email address, please contact us at support@simple.careers. 
# 
#       """
#   m.call "/messages/send", params, (res) ->
#     cb null,res
#   , (err) ->
#     cb err
# 
# app.get "/auth/v1/reset/:token", (req, res) ->
#   token = req.params.token
#   User.findOne {resetToken: token}, (err, user) ->
#     (res.send 401; return) if err
#     if(user)
#       user.set "verified", true
#       user.save ->
#         res.redirect("http://www.simple.careers/pages/reset.html?token=#{token}");
#     else
#       res.redirect("http://www.simple.careers/pages/resetdenied.html");
# 
# app.post "/auth/v1/setpass", (req, res) ->
#   token = req.body.token
#   password = req.body.password
#   (res.send 401; return) if not token
#   User.findOne {resetToken: token}, (err, user) ->
#     user.setPassword password, ->
#       require('crypto').randomBytes 48, (err, buf)->
#         (res.send 401; return) if err
#         newtoken = buf.toString('hex')
#         user.set "resetToken", newtoken
#         user.save (err)->
#           (res.send 401; return) if err
#           sendConfirmResetPassword user.username, (err)->
#             (res.send 401; return) if err
#             res.send 200
# 
# app.post "/auth/v1/reset", (req, res) ->
#   (res.send 401; return) if not req.body.email
#   User.findByUsername req.body.email, (err, user) ->
#     (res.send 401; return) if err or not user
#     require('crypto').randomBytes 48, (err, buf)->
#       (res.send 401; return) if err
#       token = buf.toString('hex')
#       user.set "resetToken", token
#       user.save (err)->
#         (res.send 401; return) if err
#         sendResetPassword req.body.email, token, (err,json)->
#           (res.send 401; return) if err
#           res.send 200