
$(document).ready ->

  currentImage = 0
  images = $ '.images img'
  menuImages = $ '.menu img'
  menuContainer = $ '.allMenu'


  move = (pixels) ->
    $('.allImages').css 'left', "#{pixels}px"

  validImage = (num) ->
    return 0 <= num < images.size()

  leftForImage = (num) ->
    left = $(window).width()/2 
    left -= $(image).width()+40 for image in images.slice 0, num
    left - (images.eq(num).width()/2)

  setCurrentImage = (num) ->
    currentImage = num
    images.removeClass 'selected'
    images.eq(currentImage).addClass 'selected'
    move leftForImage num

  resizeThumbnailContainer = ->
    width = 0
    menuImages.each (i, image) ->
      width += $(image).width()+20

    menuContainer.css 'width', width

  $('.arrow.left').on 'click', -> 
    return unless validImage currentImage-1
    setCurrentImage currentImage-1

  $('.arrow.right').on 'click', -> 
    return unless validImage currentImage+1
    setCurrentImage currentImage+1

  images.each (i, image) ->
    $(image).on 'click', -> setCurrentImage i


  loaded = 0
  menuImages.each (i, image) ->
    $(image).on 'load', -> 
      if ++loaded is menuImages.size()-1
        resizeThumbnailContainer()

    $(image).on 'click', -> setCurrentImage i

  setCurrentImage currentImage
