"use strict"
path = require("path")

###
Send our single page app
###
exports.index = (req, res) ->
  res.render(path.resolve(__dirname + '/../../../frontend/dist/index.html'));
  return
