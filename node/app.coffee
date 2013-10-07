###
Module dependencies.
###
config = require("./config")
express = require("express")
lessMiddleware = require('less-middleware')
path = require("path")
http = require("http")
socketIo = require("socket.io")
osc = require('node-osc')
exec = require('child_process').exec
path = require('path')
pubDir = path.join(__dirname, 'public')

# create app, server, and web sockets
app = express()
server = http.createServer(app)
io = socketIo.listen(server)

# Make socket.io a little quieter
io.set "log level", 1

app.configure ->
  bootstrapPath = path.join(__dirname, 'assets','css', 'bootstrap')
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
  app.use express.session(secret: "shhhh")
  app.use app.router
  app.use lessMiddleware
        src: path.join(__dirname,'assets','css')
        paths  : bootstrapPath
        dest: path.join(__dirname,'public','css')
        prefix: '/css'
        compress: true
  app.use express.static(pubDir)
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

  socket.on "on", (data) ->
    console.log "on!"
    oscClient.send "/lights", "on"

  socket.on "off", (data) ->
    console.log "off!"
    oscClient.send "/lights", "off"

  socket.on "near", (data) ->
    console.log "near!"
    oscClient.send "/lights", "near"

  socket.on "far", (data) ->
    console.log "far!"
    oscClient.send "/lights", "far"

#oscServer.on "message", (msg, info) ->
  #console.log msg
  #if msg[0].match "/active"
    #console.log msg

# you need to be signed for this business!
app.all "/auth/login", (req, res) ->
  console.log req.body.password
  console.log process.env.STUDIO_PASSWORD
  if req.body.password?.match(process.env.STUDIO_PASSWORD)
    req.session['auth'] = 'so-good'
    return res.redirect('/')
  return res.render('auth/login.jade', info:"you clearly don't know whats up")

# UI routes
app.get "/", (req, res) ->
  console.log req.session.auth
  if !req.session.auth?.match('so-good')
    return res.render 'auth/login'
  res.render "index.jade",
    title: "Studio Time"


child = exec 'python ../pi/pi.py', (error, stdout, stderr)-> 
    console.log('stdout: ' + stdout);
    console.log('stderr: ' + stderr);
    if error != null
      console.log('exec error: ' + error);

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

