"use strict"
api = require("./controllers/api")
index = require("./controllers")
linkedin = require("./controllers/linkedin")
facebook = require("./controllers/facebook")
users = require("./controllers/users")
session = require("./controllers/session")
middleware = require("./middleware")
passport = require "passport"
annotate = require "./controllers/annotate"
###
Application routes
###
module.exports = (app) ->
  
  # Server API Routes
  # app.get('/api/awesomeThings', api.awesomeThings);
  
  # app.post('/api/users', users.create);
  # app.put('/api/users', users.changePassword);
  # app.get('/api/users/me', users.me);
  # app.get('/api/users/:id', users.show);
  # 
  # app.post('/api/session', session.login);
  # app.del('/api/session', session.logout);

  # Linkedin
  app.get "/auth/linkedin", linkedin.auth     
  app.get "/auth/linkedin/callback", passport.authenticate("linkedin",
    failureRedirect: "/auth/linkedin"
  ), linkedin.callback

  app.get "/auth/facebook", facebook.auth  
  app.get "/auth/facebook/callback", passport.authenticate("facebook",
    failureRedirect: "/auth/facebook"
  ), facebook.callback
  
  # All undefined api routes should return a 404
  # app.get "/api/*", (req, res) ->
  #   res.send 404
  #   return
  # Annotate
  app.use "/annotate/", annotate

  # Baucis
  app.get /^\/docs(\/.*)?$/, api.swagger  
  app.use "/api/data/", api.baucis
    
  # All other routes to use Angular routing in app/scripts/app.js
  # app.get /^(((?!\/api\/data\/).)*&((?!\/annotate\/).))$/, middleware.setUserCookie, index.index
  app.get /^(?!\/api\/data)(?!\/annotate)(?!\/startup).*$/, middleware.setUserCookie, index.index
  # app.get /^(?!\/api\/data)(?!\/annotate).*$/, middleware.setUserCookie, index.index
  
  # app.get /^[(?!\/api\/data\/)|(?!\/annotate\/)].*$/, middleware.setUserCookie, index.index
  return