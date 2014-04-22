# process.on 'uncaughtException', (err)->
#   console.log(err)

express = require "express"
  
app = express()
app.use(express.basicAuth('simple', 'simple@1331'));
app.use(express.static(__dirname + '/dist'));
app.use(express.logger());
app.use(express.cookieParser());
app.use(express.bodyParser());
app.use(express.methodOverride());

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  return

app.configure "production", ->
  app.use express.errorHandler()
  return

port = process.env.PORT || 8080
# Listening
app.listen port
console.log "Listening on #{port}"
