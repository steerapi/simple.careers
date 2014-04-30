"use strict"
express = require("express")
path = require("path")
config = require("./config")
passport = require("passport")
mongoStore = require("connect-mongo")(express)
cors = require 'cors'
engines = require('consolidate');

###
Express configuration
###
module.exports = (app) ->
  app.configure "development", ->
    app.use require("connect-livereload")()
    
    # Disable caching of scripts for easier testing
    app.use noCache = (req, res, next) ->
      if req.url.indexOf("/scripts/") is 0
        res.header "Cache-Control", "no-cache, no-store, must-revalidate"
        res.header "Pragma", "no-cache"
        res.header "Expires", 0
      next()
      return

    # app.use express.static(path.join(config.root, ".tmp"))
    # app.use express.static(path.join(config.root, "app"))
    # app.set "views", config.root + "/app/views"
    # console.log path.resolve __dirname + '/../../../frontend/.tmp'
    # console.log path.resolve __dirname + '/../../../frontend/app'
    app.use(express.static(__dirname + '/../../../frontend/.tmp'));
    app.use(express.static(__dirname + '/../../../frontend/app'));
    return

  app.configure "production", ->
    app.use express.compress()
    # app.use express.favicon(path.join(config.root, "public", "favicon.ico"))
    # app.use express.static(path.join(config.root, "public"))
    # app.set "views", config.root + "/views"
    
    app.use(express.static(__dirname + '/../../../frontend/dist'));
    return
  # 
  # app.configure "jokno", ->
  #   app.use express.compress()
  #   # app.use express.favicon(path.join(config.root, "public", "favicon.ico"))
  #   # app.use express.static(path.join(config.root, "public"))
  #   # app.set "views", config.root + "/views"
  # 
  #   app.use(express.static(__dirname + '/../../../frontend/dist'));
  #   return
  # 
  # app.configure "100k", ->
  #   app.use express.compress()
  #   # app.use express.favicon(path.join(config.root, "public", "favicon.ico"))
  #   # app.use express.static(path.join(config.root, "public"))
  #   # app.set "views", config.root + "/views"
  # 
  #   app.use(express.static(__dirname + '/../../../frontend/dist'));
  #   return

  app.configure ->
    app.engine('html', engines.ejs);
    app.set "view engine", "ejs"
    app.use(cors());
    app.use express.logger("dev")
    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()
    app.use express.cookieParser()

    # Persist sessions with mongoStore
    app.use express.session(
      secret: "simplecareers1331"
      cookie: { maxAge: 24 * 60 * 60 * 1000 }
      store: new mongoStore(
        clear_interval: 3600
        url: config.mongo.uri
        collection: "sessions"
      , ->
        console.log "db connection open"
        return
      )
    )
    
    #use passport session
    app.use passport.initialize()
    app.use passport.session()
    
    # Router (only error handlers should come after this)
    app.use app.router
    return

  
  # Error handler
  app.configure "development", ->
    app.use express.errorHandler()
    return

  return