###
Module dependencies.
###
config = require("./config")
express = require("express")
path = require("path")
http = require("http")
routes = require('./routes')
socketIo = require("socket.io")
osc = require("node-osc")
mongoose = require("mongoose")
MongoStore = require("connect-mongo")(express)
passport = require("passport")
LocalStrategy = require("passport-local").Strategy
sessionStore = new MongoStore(url: config.mongodb)
models = require('./models')
User = models.User
exec = require('child_process').exec

passport.use "email", new LocalStrategy(
  usernameField: "email"
, (email, password, done) ->
  process.nextTick ->
    User.authEmail email, password, done
)

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    done err, user

# connect the database
mongoose.connect config.mongodb

# create app, server, and web sockets
app = express()
server = http.createServer(app)
io = socketIo.listen(server)

# Make socket.io a little quieter
io.set "log level", 1

# Give socket.io access to the passport user from Express
#io.set('authorization', passportSocketIo.authorize(
  #sessionKey: 'connect.sid',
  #sessionStore: sessionStore,
  #sessionSecret: config.sessionSecret,
  #fail: (data, accept) ->
  #keeps socket.io from bombing when user isn't logged in
    #accept(null, true);
#));
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  
  # use the connect assets middleware for Snockets sugar
  app.use require("connect-assets")()
  app.use express.favicon()
  app.use express.logger(config.loggerFormat)
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser(config.sessionSecret)
  app.use express.session(store: sessionStore)
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use require("less-middleware")(src: __dirname + "/public")
  app.use express.static(path.join(__dirname, "public"))
  app.use express.errorHandler()  if config.useErrorHandler

oscServer = new osc.Server 8888, '0.0.0.0'
oscClient = new osc.Client "0.0.0.0", 8889

io.sockets.on "connection",  (socket) ->

  socket?.emit "connection", "I am your father"

  socket.on "disconnect", ->
    console.log "disconnected"

  socket.on "lock", (data) ->
    console.log "lock!"
    oscClient.send "/door", "lock"

  socket.on "unlock", (data) ->
    console.log "unlock!"
    oscClient.send "/door", "unlock"

oscServer.on "message", (msg, info) ->
  #console.log msg
  #if msg[0].match "/active"
    #console.log msg

app.post "/auth/email", routes.ui.auth.email

app.get "/auth/success", routes.ui.auth.success
app.get "/auth/failure", routes.ui.auth.failure
app.get "/auth/logout", routes.ui.auth.logout

app.put "/me", routes.ui.me.update

# you need to be signed for this business!
app.all "/*", routes.ui.auth.signIn

# UI routes
app.get "/", (req, res) ->
  res.render "index.jade",
    title: "Studio Time"

app.get "/me", routes.ui.me.show

#app.post "/auth/registerEmail", routes.ui.auth.registerEmail

child = exec 'python ../pi/pi.py', (error, stdout, stderr)-> 
    console.log('stdout: ' + stdout);
    console.log('stderr: ' + stderr);
    if error != null
      console.log('exec error: ' + error);

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

