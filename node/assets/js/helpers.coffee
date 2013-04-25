
@a = @a || {}

@map = (value, fromMin, fromMax, toMin, toMax) ->
  norm = undefined
  value = parseInt(value)
  fromMin = parseInt(fromMin)
  fromMax = parseInt(fromMax)
  toMin = parseInt(toMin)
  toMax = parseInt(toMax)
  norm = (value - fromMin) / (fromMax - fromMin).toFixed(1)
  norm * (toMax - toMin) + toMin

Array.prototype.remove = (from, to) ->
  rest = @.slice((to || from) + 1 || @.length)
  if from < 0
    @.length = @.length + from
  else
    @.length = from
  return @.push.apply(@, rest)

@random = (min, max) ->
  if !max
    max = min
    min = 0
  Math.round Math.random() * (max - min) + min

a.animateTiles = (id)  ->
  if id
    div = $("#level1 ##{id} .level1")
  else
    div = $('.level1')
  $(div).each ->
    me = @
    if $(me).attr "hidden"
      $(me).addClass "hidden"
    else
      $(me).removeClass "hidden"
      setTimeout ->
        $(me).animate {
          opacity: 1
        }, 200
      , $(me).index() * 100
        
      #$(me).animate {
        #left: $(me).attr("left"),
        #top: $(me).attr("top")
      #}, 400, ->
        #if $(me).attr "tall"
          #$(me).children("img").css "width", "auto"
          #$(me).children("img").css "height", $(me).height()
        #else
          #$(me).children("img").css "width", $(me).width()
          #$(me).children("img").css "height", "auto"
        #$(me).css "overflow", "hidden"
      
a.resetTiles= (id) ->
  if id
    div = $("#level1 #{id} .level1")
  else
    div = $('.level1')
  $(".level1.open").trigger "click"
  $(div).removeClass "active"
  $(div).removeClass "hidden"
  #$(div).each ->
    #me = @
    #$(me).animate {
      #left: -1000
      #top: -1000
    #}, 100

a.handleBucketClick = (me) ->
  aTime = 400
  if a.open
    a.open = false
    #$(me).css "position", "static"
    $(me).animate {
      left: $(me).attr("x0"),
      top: $(me).attr("y0"),
      width: $(me).attr("w0"),
      height: $(me).attr("h0"),
    }, aTime, ->
      $(me).removeClass "open"
      if $(me).data "tall"
        $(me).children("img").css "width", "auto"
        $(me).children("img").css "height", "100%"
      else
        $(me).children("img").css "width", "100%"
        $(me).children("img").css "height", "auto"
      $(me).css "overflow", "hidden"
    #setTimeout ->
      #$('.level1').fadeIn(aTime)
    #, aTime

  else
    a.open = true
    #$('.level1').not(me).hide()
    #$(me).css("z-index", 100).css "position", "fixed"
    $(me).addClass "open"
    #$('#level1').animate {
      #scrollTop: 0+"px"
    #}, 300, ->
    $(me).animate {
      top: -10,#$('#level1').scrollTop(),
      left: -10,
      width: $(window).width() + 20,
      height: $(window).height() + 20,
    }, 400
    #$img = $(me).find('img')
    #wrapW = $(window).width()
    #$img.css("left", ( wrapW / 2 ) - ( $img.width() / 2 )
    #$(me).children('img').height($(window).height())
