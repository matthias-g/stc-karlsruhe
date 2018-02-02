#= require swiper

class @GallerySlider
  constructor: (@html) ->

    @galleryTop = new Swiper(@html.children('.gallery-top'),
      spaceBetween: 10
      navigation:
        nextEl: '.swiper-button-next'
        prevEl: '.swiper-button-prev'
      autoplay:
        delay: 4000
        disableOnInteraction: true
      speed: 800
    )

    @galleryThumbs = new Swiper(@html.children('.gallery-thumbs'),
      spaceBetween: 10
      centeredSlides: true
      slidesPerView: 'auto'
      touchRatio: 0.2
      slideToClickedSlide: true
    )

    @galleryTop.controller.control = @galleryThumbs
    @galleryThumbs.controller.control = @galleryTop