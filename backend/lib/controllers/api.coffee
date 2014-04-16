'use strict';

baucis = require "baucis"
swagger = require('baucis-swagger')
passport = require("../config/passport")

baucis.rest("user").request passport.authenticate('bearer', { session: false })
baucis.rest("job")
bApp = baucis
  swagger: true
  version: "1.0.0"
  # release: "1.0.0"
  
module.exports = bApp