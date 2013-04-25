passport = require("passport")
User = require("../../models").User

exports.email = passport.authenticate("email",
  successRedirect: "/auth/success"
  failureRedirect: "/auth/failure"
  failureFlash: true
)
exports.registerEmail = (req, res) ->
  User.registerEmail req.body.name, req.body.email, req.body.password, req.body.passwordConfirm, (err, user) ->
    return res.send(500)  if err
    exports.email req, res


exports.signIn = (req, res, next) ->
  if req.user
    if req.user.name == 'foo'
      args = 
        title: 'Profile'
        bands: req.jsonData
        user : req.user || { name: '-1', id: '-1' }
        needsUpdate: true
      res.render 'me/index', args
    else
      next()
  else
    res.render "auth/signIn.jade"

exports.logout = (req, res) ->
  req.logout()
  res.redirect "/"

exports.success = (req, res) ->
  res.redirect "/"

exports.failure = (req, res) ->
  res.redirect "/"
