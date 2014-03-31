fs = require "fs"
_ = require "lodash"
txt = fs.readFileSync "job.txt"
str = txt+""
lines = str.split "\n"
lines = lines.filter (line)=>
  line != ''
lines = _.unique lines
for line in lines
  console.log line
# console.log lines
# console.log lines.length
