
$(document).ready ->

  console.log $('.contentImage').length

  $('.allMenu').slick
    arrows: true
    slidesToShow: $('.contentImage').length - 1
    asNavFor: '.allImages'
    dots: false
    centerMode: true
    focusOnSelect: true
    variableWidth: true
    swipeToSlide: true

  $('.allImages').slick
    slidesToShow: 1
    arrows: true
    fade: true
    centerMode: true
    adaptiveHeight: true
    speed: 300
    asNavFor: '.allMenu'

  ###move = (pixels) ->
    $('.allImages').css 'left', "#{pixels}px"

  validImage = (num) ->
    return 0 <= num < images.size()

  leftForImage = (num) ->
    margin = 40
    left = $(window).width()/2
    left -= $(image).width()+margin for image in images.slice 0, num
    left - images.eq(num).width()/2

  setCurrentImage = (num) ->
    currentImage = num
    images.removeClass 'selected'
    images.eq(currentImage).addClass 'selected'
    move leftForImage num

  resizeThumbnailContainer = ->
    width = 0
    menuImages.each (i, image) ->
      width += $(image).width()+22

    menuContainer.css 'width', width

  $('.arrow.left').on 'click', ->
    return unless validImage currentImage-1
    setCurrentImage currentImage-1

  $('.arrow.right').on 'click', ->
    return unless validImage currentImage+1
    setCurrentImage currentImage+1

  images.each (i, image) ->
    $(image).on 'click', -> setCurrentImage i

  menuImages.each (i, image) ->
    $(image).on 'load', ->
      resizeThumbnailContainer()

    $(image).on 'click', -> setCurrentImage i###

  $('.login').on 'click', (e) ->
    $('.login').addClass 'focused'
    $('.login input').focus()
    e.preventDefault()

  $('.login').on 'keypress', (e) ->
    input = $('.login input')

    if e.which is 13
      window.location.href = '/client/'+$('.login input').val()
      e.preventDefault()


  #setCurrentImage currentImage
  #resizeThumbnailContainer()
