# process.on 'uncaughtException', (err)->
#   console.log(err)

mandrill = require("mandrill-api")
mongoose = require "mongoose"
mongooseCachebox = require "mongoose-cachebox"
options =
  cache: true # start caching
  ttl: 30 # 30 seconds

express = require "express"
Schema = require "./lib/schema"
Schema.list.forEach (item)->
  mongoose.model item.toLowerCase(), Schema[item]

# Application Config
config = require("./lib/config/config")

# Connect to database
db = mongoose.connect(config.mongo.uri, config.mongo.options)

mongoose.connection.on "error", ->
  console.log arguments...
mongoose.connection.once "open", ->
  console.log arguments...

# Passport Configuration
passport = require("./lib/config/passport")

app = express()

app.use("/pages",express.static(__dirname + '/../frontend/pages'));
app.use("/startup",require("../startup"));

require("./lib/config/express") app

# Baucis
# api = require("./lib/controllers/api")
# app.get /^\/docs(\/.*)?$/, api.swagger  
# app.use "/api/data/", api.baucis

# Routing
require("./lib/routes") app

# Start server
app.listen config.port, ->
  console.log "Express server listening on port %d in %s mode", config.port, app.get("env")
  return
