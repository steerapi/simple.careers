express = require "express"
app = express()
app.use(express.static(__dirname + '/site'));
module.exports = app