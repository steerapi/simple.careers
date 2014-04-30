'use strict';

express = require "express"
path = require "path"

app = express()

config = require("../config/config")

app.use(express.basicAuth(config.annotate.username, config.annotate.password));
app.configure "development", ->
  app.use(express.static(path.resolve(__dirname+'/../../../annotate/.tmp')));
  app.use(express.static(path.resolve(__dirname+'/../../../annotate/app')));
app.configure "production", ->
  app.use(express.static(path.resolve(__dirname+'/../../../annotate/dist')));
# app.configure "jokno", ->
#   app.use(express.static(path.resolve(__dirname+'/../../../annotate/dist')));
  
app.use(express.logger());
app.use(express.cookieParser());
app.use(express.bodyParser());
app.use(express.methodOverride());

module.exports = app