#= require swiper

class @MultiImageSlider
  constructor: (@html) ->
    new Swiper(@html,
      slidesPerView: 'auto'
      speed: 1000
      autoplay:
        delay: 3000
        disableOnInteraction: false
      spaceBetween: 5
      preloadImages: false
      lazy: true
      watchSlidesVisibility: true
      freeMode: true
      loop: true
      loopedSlides: 9
    )