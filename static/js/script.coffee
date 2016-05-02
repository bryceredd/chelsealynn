
$(document).ready ->

  $('.allMenu').slick
    #slidesToShow: $('.contentImage').length - 1
    #slidesToShow: 2
    slidesToScroll: 10
    slidesToShow: 1
    asNavFor: '.allImages'
    #dots: true
    centerMode: true
    focusOnSelect: true
    variableWidth: true
    # swipeToSlide: true
    infinite: false

  $('.allImages').slick
    slidesToShow: 1
    arrows: false
    fade: true
    #centerMode: true
    adaptiveHeight: true
    speed: 300
    asNavFor: '.allMenu'

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
