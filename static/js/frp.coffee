
$(document).ready ->

  images = $('.images img')
  container = $('.allImages')

  right = $('.arrow.right').asEventStream("click").map 1
  left = $('.arrow.left').asEventStream("click").map -1


  currentImageStream = right.merge(left)
    .scan 0, (current, incoming) -> 
      Math.max 0, Math.min images.size()-1, current + incoming


  leftPositionStream = currentImageStream
    .map (x) -> 
      left = $(window).width()/2
      left -= $(image).width()+20 for image in images.slice 0, x
      left - (images.eq(x).width()/2)
  
  leftPositionStream.assign $('.allImages'), 'css', 'left'


  images.each (i, image) ->
    currentImageStream.map((x) -> x == i)
    .assign $(image), 'toggleClass', 'selected'

