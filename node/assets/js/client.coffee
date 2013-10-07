#= require jquery
#= require underscore
# =require backbone
#= require bootstrapManifest
# =require socket.io
# =require helpers

@a = @a || {}

$(window).ready ->
  # set up the socket.io and OSC
  socket = io.connect() 
  a.socket = socket

  socket.on "connection", (msg) ->
    console.log "connected"
    socket.emit "hello", "world"

  $('.lock').click ->
    socket.emit "lock"

  $('.unlock').click ->
    socket.emit "unlock"

  $('.off').click ->
    socket.emit "off"

  $('.on').click ->
    socket.emit "on"

  $('.far').click ->
    socket.emit "far"

  $('.near').click ->
    socket.emit "near"
