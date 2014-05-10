"use strict"
path = require("path")

mongoose = require("mongoose")
Job = mongoose.model("job")

###
Send our single page app
###
exports.index = (req, res) ->
  userAgent = req.get('User-Agent');
  result = req.path.match /\/app\/all\/(\d+)/
  if result
    idx = result[1]
    Job.find().skip(idx).limit(1).exec (err,jobs)->
      if jobs.length == 0
        return
      job = jobs[0]
      if /facebookexternalhit/.test userAgent
        res.send """
        <html>
          <head>
          <meta property="og:title" content="#{job.companyname}: #{job.position}"/>
          <meta property="og:image" content="#{job.picture.url}"/>
          <meta property="og:description" content="#{job.companytagline}. #{job.jobtagline}"/>
          </head>
        </html>
        """
      else
        res.render(path.resolve(__dirname + '/../../../frontend/dist/index.html'));
  else
    res.render(path.resolve(__dirname + '/../../../frontend/dist/index.html'));
  return
