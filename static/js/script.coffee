
###$('.arrow.right').on 
  mouseenter: ->
    scroller = setInterval (-> 
      $('.images')[0].scrollLeft += 3
    ), 1
  mouseleave: ->
    clearInterval scroller


$('.arrow.left').on
  mouseenter: ->
    scroller = setInterval (-> 
      $('.images')[0].scrollLeft -= 3
    ), 1
  mouseleave: ->
    clearInterval scroller###


currentImage = 0
currentX = 0
images = $('.images img')


move = (pixels) =>
  $('.allImages').css 'left', "#{currentX += pixels}px"

$('.arrow.left').on 'click', -> 
  return unless validImage currentImage-1
  move images[currentImage].width
  setCurrentImage currentImage-1

$('.arrow.right').on 'click', -> 
  return unless validImage currentImage+1
  move -images[currentImage].width
  setCurrentImage currentImage+1

validImage = (num) ->
  return 0 <= num < images.size()

setCurrentImage = (num) ->
  currentImage = num
  images.removeClass 'selected'
  images.eq(currentImage).addClass 'selected'

setCurrentImage 0
