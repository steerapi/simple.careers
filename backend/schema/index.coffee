list = []
require("fs").readdirSync("./schema").forEach (file) ->
  file = file.split(".")[0]
  list.push file
list = list.filter (item)->
  item.length > 0 && item != "index"
list.forEach (item)->
  exports[item] = require "./#{item}.coffee"
exports.list = list
