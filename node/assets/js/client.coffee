#= require jquery
#= require bootstrapManifest
# =require socket.io

@a = @a || {}

$(window).ready ->

  # set up the socket.io and OSC
  @a.socket = socket = io.connect() 
  a.socket = socket

  socket.on "connection", (msg) ->
    console.log "connected"
    socket.emit "hello", "world"

  socket.on "imageUpdate", (msg) ->
    $("#live").attr 'src', "data:image/jped;base64,#{msg}"

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

  $('.left').click ->
    socket.emit "left"

  $('.right').click ->
    socket.emit "right"
