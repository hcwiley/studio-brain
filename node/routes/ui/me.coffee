me = require("../api/me")
exports.show = (req, res) ->
  me.show req, res, ->
    res.render "me/index",
      title: "Profile"
      user: req.user

exports.update = (req, res) ->
  me.update req, res, ->
    res.redirect "/me"

