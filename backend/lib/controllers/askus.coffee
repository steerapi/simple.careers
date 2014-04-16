# sendAskus = (fromName, fromEmail, message, cb)->
#   # Send the email!
#   m = new mandrill.Mandrill(config.mandrill)
#   params = 
#     message:
#       from_email: "#{fromEmail}"
#       to: [email: "support@simple.careers"]
#       subject: "Askus from #{fromName}"
#       text: message
#   m.call "/messages/send", params, (res) ->
#     cb null,res
#   , (err) ->
#     cb err
#   
# app.post "/askus", (req, res) ->
#   # Auth success
#   Askus.create req.body, ->
#     res.send 200
#     sendAskus req.body.name, req.body.email, req.body.text, ->
