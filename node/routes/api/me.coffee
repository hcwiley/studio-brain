exports.show = (req, res, next) ->
  res.jsonData = (if req.user then req.user else {})
  next()

exports.update = (req, res, next) ->
  console.log req.body
  user = req.user
  user.email = req.body.email
  user.name = req.body.name
  user.password = req.body.password  if req.body.password
  user.save (err, user) ->
    return res.send(500)  if err
    req.apiData = user
    next()

