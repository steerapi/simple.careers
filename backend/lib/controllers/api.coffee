'use strict';

baucis = require "baucis"
swagger = require('baucis-swagger')
passport = require("passport")
express = require "express"
path = require "path"

api = {}
baucis.rest("user").request passport.authenticate('bearer', { session: false })
baucis.rest
  singular: 'job'
  put: false
  post: false
  del: false
baucis.rest("askus")
baucis.rest("userapply").request passport.authenticate('bearer', { session: false })
baucis.rest("userfavorite").request passport.authenticate('bearer', { session: false })
api.baucis = baucis
  swagger: true
  version: "1.0.0"
  # release: "1.0.0"
 
docs_handler = express.static(path.resolve(__dirname + "/../../swagger-ui/"))
api.swagger = (req, res, next) ->
  if req.url is "/docs" # express static barfs on root url w/o trailing slash
    res.writeHead 302,
      Location: req.url + "/"
    res.end()
    return
  # take off leading /docs so that connect locates file correctly
  req.url = req.url.substr("/docs".length)
  docs_handler req, res, next
 
module.exports = api