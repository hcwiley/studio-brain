#= require jquery
#= require underscore
# =require backbone
#= require bootstrapManifest
# =require socket.io
# =require helpers

@a = @a || {}

@a.entries = {}


$(window).ready ->
  # set up the socket.io and OSC
  socket = io.connect() 
  a.socket = socket

  socket.on "connection", (msg) ->
    socket.emit "pageId", a.pageId
    socket.emit "getContent", a.pageId

  $('.lock').click ->
    socket.emit "lock"

  $('.unlock').click ->
    socket.emit "unlock"

