mongoose = require "mongoose"
mongooseTypes = require "mongoose-types"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
mongooseTypes.loadTypes(mongoose, "email");
Email = Schema.Types.Email
bcrypt = require 'bcrypt'

UserSchema = new Schema(
  name:
    type: String

  email:
    type: Email
    unique: true

  salt:
    type: String

  hash:
    type: String
)

UserSchema.virtual("password").get( ->
  @_password
).set (password) ->
  @_password = password
  salt = @salt = bcrypt.genSaltSync(10)
  @hash = bcrypt.hashSync(password, salt)

UserSchema.method "checkPassword", (password, callback) ->
  console.log "checking password"
  bcrypt.compare password, @hash, callback

UserSchema.static "registerEmail", (name, email, password, passwordConfirm, callback) ->
  return callback("PASSWORD_MISMATCH", false)  unless password is passwordConfirm
  user = new this(
    name: name
    email: email
    password: password
  )
  user.save (err, user) ->
    callback err, false  if err
    callback null, user

UserSchema.static "authEmail", (email, password, callback) ->
  console.log "authing email"
  @findOne
    email: email
  , (err, user) ->
    return callback(err)  if err
    return callback(null, false)  unless user
    user.checkPassword password, (err, isCorrect) ->
      return callback(err)  if err
      return callback(null, false)  unless isCorrect
      callback null, user

User = exports.User = mongoose.model 'User', UserSchema 
