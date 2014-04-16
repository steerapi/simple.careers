request = require "superagent"
config = require("./config.coffee")
mongoose = require "mongoose"

mongoose.connect "mongodb://simple:simple1331@ec2-54-196-28-191.compute-1.amazonaws.com:27017/simplecareers"
db = mongoose.connection
db.on "error", ->
  console.log arguments...
db.once "open", ->
  console.log "open",arguments...

express = require "express"
Schema = require "./schema"
en = require('lingo').en
  
# Register the schemata and retrieve user database
Models = {}
Schema.list.forEach (item)->
  Models[item] = mongoose.model item.toLowerCase(), Schema[item]

User = Models["User"]
Job = Models["Job"]
Askus = Models["Askus"]
UserApply = Models["UserApply"]
UserFavorite = Models["UserFavorite"]

request.get "https://api.angel.co/1/jobs", (res)=>
  # console.log JSON.stringify res.body.jobs, null, 5
  last_page = res.body.last_page
  page = 1
  k = 0
  for page in [1..last_page]
    request.get "https://api.angel.co/1/jobs?page=#{page}", (res)=>
      for job in res.body.jobs
        badges = []
        location = undefined
        for tag in job.tags
          if tag.tag_type == "SkillTag"
            badges.push
              name: tag.display_name
          if tag.tag_type == "LocationTag"
            location = tag.display_name
        Job.
          companyname: job.startup.name
          companytagline: job.startup.high_concept
          joblocation: location
          picture: 
            url: job.startup.logo_url
          logo:
            url: job.startup.thumb_url
          jobtagline: job.startup.product_desc
          positionname: job.title
          badges: badges
          worktype: "Full-time"
          compensation: "$#{job.salary_max}/#{job.equity_max}}%"
          order: k++
          source: "angel.co"
          _json: job