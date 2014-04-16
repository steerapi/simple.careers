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
Schema = require "./lib/schema"

Schema.list.forEach (item)->
  mongoose.model item.toLowerCase(), Schema[item]

# Application Config
config = require("./lib/config/config")

# Passport Configuration
passport = require("./lib/config/passport")
app = express()

# app.use("/pages",express.static(__dirname + '/../frontend/pages'));

require("./lib/config/express") app

# Routing
require("./lib/routes") app

# Start server
app.listen config.port, ->
  console.log "Express server listening on port %d in %s mode", config.port, app.get("env")
  return
